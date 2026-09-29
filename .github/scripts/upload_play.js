const fs = require("fs");
const { google } = require("googleapis");

async function main() {
  const keyFile = process.env.KEY_FILE;
  const packageName = process.env.PACKAGE_NAME;
  const aab = process.env.AAB_PATH;
  const track = process.env.PLAY_TRACK;
  const releaseName = process.env.RELEASE_NAME;
  const mappingFile = process.env.MAPPING_FILE;
  const notesDir = process.env.NOTES_DIR;
  const changesNotSentForReview = process.env.CHANGES_NOT_SENT_FOR_REVIEW === "true";

  const auth = new google.auth.GoogleAuth({
    keyFile,
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  const androidpublisher = google.androidpublisher({ version: "v3", auth });
  const edit = await androidpublisher.edits.insert({ packageName });
  const editId = edit.data.id;
  const bundle = await androidpublisher.edits.bundles.upload({
    packageName,
    editId,
    media: {
      mimeType: "application/octet-stream",
      body: fs.createReadStream(aab),
    },
  });
  const versionCode = bundle.data.versionCode;
  if (!versionCode) {
    throw new Error("Play did not return a version code");
  }

  if (mappingFile && fs.existsSync(mappingFile)) {
    await androidpublisher.edits.deobfuscationfiles.upload({
      packageName,
      editId,
      apkVersionCode: versionCode,
      deobfuscationFileType: "proguard",
      media: {
        mimeType: "application/octet-stream",
        body: fs.createReadStream(mappingFile),
      },
    });
  }

  const releaseNotes = [];
  if (notesDir && fs.existsSync(notesDir)) {
    for (const file of fs.readdirSync(notesDir)) {
      const match = /^whatsnew-(.+)$/.exec(file);
      if (!match) continue;
      releaseNotes.push({
        language: match[1],
        text: fs.readFileSync(`${notesDir}/${file}`, "utf8").trim(),
      });
    }
  }

  await androidpublisher.edits.tracks.update({
    packageName,
    editId,
    track,
    requestBody: {
      track,
      releases: [
        {
          name: releaseName,
          status: "completed",
          versionCodes: [String(versionCode)],
          releaseNotes,
        },
      ],
    },
  });
  await androidpublisher.edits.commit({
    packageName,
    editId,
    changesNotSentForReview,
  });
  console.log(`Uploaded versionCode ${versionCode} to ${track}`);
}

main().catch((error) => {
  const detail = error.response?.data?.error?.message || error.message;
  console.error(detail);
  process.exit(1);
});
