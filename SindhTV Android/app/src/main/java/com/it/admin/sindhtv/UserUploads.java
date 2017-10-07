package com.it.admin.sindhtv;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.PopupWindow;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.it.utility.AndroidMultiPartEntity;
import com.it.utility.EmailFetcher;
import com.it.utility.WebServicesUrls;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

/**
 * Created by admin on 4/28/2016.
 */
public class UserUploads extends AppCompatActivity implements View.OnClickListener {
    private SharedPreferences shp;

    private String channelID, bgColor, tabBgColor, tabSepColor, tabUnderColor, actionbarColor, listBgColor, tabTextColor, listTextColor;

    private EditText editNameUpload, editEmailUpload, editFeedbackUpload, editPasswordUpload;

    private Button btnSelectTypeFeedback, btnSubmitTypeFeedback;

    private PopupWindow popupWindow, popupImage, popupVideo;

    //  private ImageView imageThumbnailRecord, imageThumbnailImage, imageThumbnailVideo, imageThumbnailVideoIcon;

    public static final int ACTIVITY_RECORD_SOUND = 123;

    private static final int CAMERA_CAPTURE_IMAGE_REQUEST_CODE = 100;

    private int RESULT_LOAD_IMAGE = 101;

    private static final int VIDEO_CAPTURE = 102;

    private static final int RESULT_LOAD_VIDEO_GALLERY = 103;

    Uri imageCarmeraUri;

    private String path = "", flagType = "";

    private TextView textPath;

    private android.media.MediaRecorder myRecorder;
    private android.media.MediaPlayer myPlayer;
    // private String outputFile = null;
    private Button startBtn;
    private Button stopBtn;
    //private Button playBtn;
    //private Button stopPlayBtn;
    //	private TextView text;
    private android.widget.Chronometer chronometer1;

    private ProgressBar progressBarVideoUplaod;

    private TextView textLoading;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.user_upoad);


        popupWindow = popupFiles();

        shp = getSharedPreferences("sindhtv", 0);

        channelID = shp.getString("channel_id", "");

        bgColor = shp.getString("bg_color", "");
        tabBgColor = shp.getString("tabbg_color", "");
        tabSepColor = shp.getString("tabseperator_color", "");
        tabUnderColor = shp.getString("tabunderline_color", "");
        actionbarColor = shp.getString("actionbar_color", "");
        listBgColor = shp.getString("listbg_color", "");
        tabTextColor = shp.getString("tabtext_color", "");
        listTextColor = shp.getString("listtext_color", "");

        String banner_code_ios = shp.getString("banner_code_ios", "");

        android.widget.LinearLayout adContainer = (android.widget.LinearLayout) findViewById(com.it.admin.sindhtv.R.id.linearAdUpload);
        com.google.android.gms.ads.AdView adView = new com.google.android.gms.ads.AdView(com.it.admin.sindhtv.UserUploads.this);
        adView.setAdSize(com.google.android.gms.ads.AdSize.SMART_BANNER);
        adView.setAdUnitId(banner_code_ios);

// Initiate a generic request to load it with an ad
        com.google.android.gms.ads.AdRequest adRequest = new com.google.android.gms.ads.AdRequest.Builder().build();

        adView.loadAd(adRequest);

        android.widget.LinearLayout.LayoutParams params = new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.MATCH_PARENT);
        adContainer.addView(adView, params);


        getSupportActionBar().setTitle("Upload");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        getSupportActionBar().setBackgroundDrawable(new ColorDrawable(Color.parseColor(actionbarColor)));


        setBackImage();


    }

    @Override
    protected void onResume() {
        super.onResume();

        String name = EmailFetcher.getName(UserUploads.this);
        String email = EmailFetcher.getEmailId(UserUploads.this);

        init();

        editNameUpload.setText(name);
        editEmailUpload.setText(email);

    }

    void init() {

       /* imageThumbnailRecord = (ImageView) findViewById(R.id.imageThumbnailRecord);
        imageThumbnailImage = (ImageView) findViewById(R.id.imageThumbnailImage);
        imageThumbnailVideo = (ImageView) findViewById(R.id.imageThumbnailVideo);
        imageThumbnailVideoIcon = (ImageView) findViewById(R.id.imageThumbnailVideoIcon);*/

        textPath = (TextView) findViewById(R.id.textPath);

        progressBarVideoUplaod = (ProgressBar) findViewById(R.id.progressBarVideoUplaod);

        textLoading = (TextView)findViewById(R.id.textLoading);

        editNameUpload = (EditText) findViewById(R.id.editNameUpload);
        editEmailUpload = (EditText) findViewById(R.id.editEmailUpload);
        editFeedbackUpload = (EditText) findViewById(R.id.editFeedbackUpload);
        editPasswordUpload = (EditText) findViewById(R.id.editPasswordUpload);

        btnSelectTypeFeedback = (Button) findViewById(R.id.btnSelectTypeFeedback);
        btnSubmitTypeFeedback = (Button) findViewById(R.id.btnSubmitTypeFeedback);

        btnSelectTypeFeedback.setOnClickListener(this);
        btnSubmitTypeFeedback.setOnClickListener(this);


    }

    @Override
    public void onClick(View v) {

        switch (v.getId()) {

            case R.id.btnSelectTypeFeedback:

                popupWindow.showAsDropDown(v, 5, 0);

                break;


            case R.id.btnSubmitTypeFeedback:

                if (editEmailUpload.getText().toString().equalsIgnoreCase("") || editFeedbackUpload.getText().toString().equalsIgnoreCase("")) {
                    Toast.makeText(UserUploads.this, "Complete your all fields first", Toast.LENGTH_SHORT).show();
                } else if (path.equals("")) {
                    Toast.makeText(UserUploads.this, "Please select file to upload", Toast.LENGTH_SHORT).show();
                } else {

                 //   new ImageUpload().execute();

                    new UploadFileToServer().execute();

                }

                break;

            default:
        }


    }

    void setBackImage() {
        final android.widget.RelativeLayout topLayoutLive = (android.widget.RelativeLayout) findViewById(R.id.layoutUpload);
        if (bgColor.equals("")) {

        } else {
            Picasso.with(UserUploads.this).load(bgColor).into(new Target() {
                @Override
                public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
                    BitmapDrawable drawableBitmap = new BitmapDrawable(bitmap);
                    topLayoutLive.setBackgroundDrawable(drawableBitmap);
                }

                @Override
                public void onBitmapFailed(Drawable errorDrawable) {

                }

                @Override
                public void onPrepareLoad(Drawable placeHolderDrawable) {

                }
            });
        }

    }

    public PopupWindow popupFiles() {


        final PopupWindow popupWindow = new PopupWindow(this);

        LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        final View view = inflater.inflate(R.layout.custom_feedback, null);

        popupWindow.setFocusable(true);
        popupWindow.setWidth(WindowManager.LayoutParams.FILL_PARENT);
        popupWindow.setHeight(WindowManager.LayoutParams.WRAP_CONTENT);

        popupWindow.setBackgroundDrawable(getResources().getDrawable(
                R.drawable.custom_edit));

        Button btnUplaodImage = (Button) view.findViewById(R.id.btnUplaodImage);
        Button btnUplaodVideo = (Button) view.findViewById(R.id.btnUplaodVideo);
        Button btnUplaodRecording = (Button) view.findViewById(R.id.btnUplaodRecording);

        btnUplaodImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                flagType = "image";

                dialogAddImages();


                popupWindow.dismiss();


            }
        });

        btnUplaodVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                flagType = "video";

                dialogAddVideo();

                popupWindow.dismiss();
            }
        });

        btnUplaodRecording.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                flagType = "audio";

                //  dialogRecord();

                Intent intent = new Intent(UserUploads.this, com.it.utility.MainActivity.class);
                startActivityForResult(intent, ACTIVITY_RECORD_SOUND);


                // Intent intent = new Intent(MediaStore.Audio.Media.RECORD_SOUND_ACTION);
                //  startActivityForResult(intent, ACTIVITY_RECORD_SOUND);


                popupWindow.dismiss();


            }
        });

        popupWindow.setContentView(view);

        return popupWindow;

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        if (resultCode == Activity.RESULT_OK) {

            if (requestCode == ACTIVITY_RECORD_SOUND) {

                // Uri u = data.getData();
                // path = getRealPathFromURI(u);

                path = data.getStringExtra("path");

                Toast.makeText(UserUploads.this, path, Toast.LENGTH_SHORT).show();


                textPath.setText(path);

                btnSelectTypeFeedback.setText("Voice Recorded");

            } else if (requestCode == CAMERA_CAPTURE_IMAGE_REQUEST_CODE) {
                path = imageCarmeraUri.getPath();
                Toast.makeText(UserUploads.this, path, Toast.LENGTH_SHORT).show();

              /*  imageThumbnailImage.setVisibility(View.VISIBLE);

                imageThumbnailVideo.setVisibility(View.GONE);
                imageThumbnailImage.setVisibility(View.GONE);
                imageThumbnailRecord.setVisibility(View.GONE);*/
                textPath.setText(path);
                btnSelectTypeFeedback.setText("Image Selected");

            } else if (requestCode == RESULT_LOAD_IMAGE) {

                Uri selectedImageUri = null;
                selectedImageUri = data.getData();
                String[] filePathColumn = {MediaStore.Images.Media.DATA};

                Cursor imageCursor = this.getContentResolver().query(
                        selectedImageUri, filePathColumn, null, null, null);

                if (imageCursor == null) {
                    return;
                }

                imageCursor.moveToFirst();
                int columnIndex = imageCursor.getColumnIndex(filePathColumn[0]);
                path = imageCursor.getString(columnIndex);
                if (path == null) {
                    path = selectedImageUri.getPath();
                    String wholeID = DocumentsContract
                            .getDocumentId(selectedImageUri);

                    // Split at colon, use second item in the array
                    String id = wholeID.split(":")[1];

                    Cursor cursor = null;

                    String[] column = {MediaStore.Images.Media.DATA};

                    // where id is equal to
                    String sel = MediaStore.Images.Media._ID + "=?";

                    cursor = this.getContentResolver().query(
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                            column, sel, new String[]{id}, null);
                    columnIndex = cursor.getColumnIndex(column[0]);


                    if (cursor.moveToFirst()) {
                        path = cursor.getString(columnIndex);
                    }

                    cursor.close();
                }
                path = new File(path).getAbsolutePath();

                Toast.makeText(UserUploads.this, path, Toast.LENGTH_SHORT).show();
                textPath.setText(path);
                btnSelectTypeFeedback.setText("Image Selected");

                imageCursor.close();

            } else if (requestCode == VIDEO_CAPTURE) {

                path = imageCarmeraUri.getPath();

                btnSelectTypeFeedback.setText("Video Selected");
                textPath.setText(path);
                Toast.makeText(UserUploads.this, path, Toast.LENGTH_SHORT).show();

            } else if (requestCode == RESULT_LOAD_VIDEO_GALLERY) {

                Uri selectedImageUri = null;
                selectedImageUri = data.getData();
                String[] filePathColumn = {MediaStore.Images.Media.DATA};

                Cursor imageCursor = this.getContentResolver().query(
                        selectedImageUri, filePathColumn, null, null, null);

                if (imageCursor == null) {
                    return;
                }

                imageCursor.moveToFirst();
                int columnIndex = imageCursor.getColumnIndex(filePathColumn[0]);
                path = imageCursor.getString(columnIndex);
                if (path == null) {
                    path = selectedImageUri.getPath();
                    String wholeID = DocumentsContract
                            .getDocumentId(selectedImageUri);

                    // Split at colon, use second item in the array
                    String id = wholeID.split(":")[1];

                    Cursor cursor = null;

                    String[] column = {MediaStore.Video.Media.DATA};

                    // where id is equal to
                    String sel = MediaStore.Video.Media._ID + "=?";

                    cursor = this.getContentResolver().query(
                            MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
                            column, sel, new String[]{id}, null);
                    columnIndex = cursor.getColumnIndex(column[0]);


                    if (cursor.moveToFirst()) {
                        path = cursor.getString(columnIndex);
                    }

                    btnSelectTypeFeedback.setText("Video Selected");

                    cursor.close();
                }
                path = new File(path).getAbsolutePath();
                textPath.setText(path);
                imageCursor.close();

                Toast.makeText(UserUploads.this, path, Toast.LENGTH_SHORT).show();

            }

        } else {
            Toast.makeText(UserUploads.this, "Try again", Toast.LENGTH_SHORT).show();
          /*  imageThumbnailImage.setVisibility(View.GONE);

            imageThumbnailVideo.setVisibility(View.GONE);
            imageThumbnailImage.setVisibility(View.GONE);
            imageThumbnailRecord.setVisibility(View.GONE);*/
        }

    }

    public String getRealPathFromURI(Uri contentUri) {
        String[] proj = {MediaStore.Images.Media.DATA};
        Cursor cursor = managedQuery(contentUri, proj, null, null, null);
        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        return cursor.getString(column_index);
    }


    void dialogAddImages() {

        final Dialog dialogDelete = new Dialog(UserUploads.this);

        dialogDelete.requestWindowFeature(Window.FEATURE_NO_TITLE);

        dialogDelete.getWindow().setBackgroundDrawable(
                new ColorDrawable(android.graphics.Color.TRANSPARENT));

        Window window = dialogDelete.getWindow();
        WindowManager.LayoutParams wlp = window.getAttributes();

        wlp.gravity = Gravity.CENTER;
        wlp.flags &= WindowManager.LayoutParams.FLAG_DIM_BEHIND;
        window.setAttributes(wlp);

        dialogDelete.setContentView(R.layout.custom_feedback);

        Button btnUplaodImage = (Button) dialogDelete.findViewById(R.id.btnUplaodImage);
        Button btnUplaodVideo = (Button) dialogDelete.findViewById(R.id.btnUplaodVideo);
        Button btnUplaodRecording = (Button) dialogDelete.findViewById(R.id.btnUplaodRecording);
        btnUplaodRecording.setVisibility(View.GONE);

        btnUplaodImage.setText("Camera");
        btnUplaodVideo.setText("Take from gallery");

        btnUplaodImage.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
        btnUplaodVideo.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);

        btnUplaodImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

                File mediaStorageDir = new File(Environment
                        .getExternalStorageDirectory(), "/SindhTV/");

                if (mediaStorageDir.exists()) {

                } else {
                    mediaStorageDir.mkdirs();
                }

                String imagePath = Environment.getExternalStorageDirectory()
                        + "/SindhTV/" + System.currentTimeMillis() + ".jpg";
                File carmeraFile = new File(imagePath);
                imageCarmeraUri = Uri.fromFile(carmeraFile);

                intent.putExtra(android.provider.MediaStore.EXTRA_OUTPUT,
                        imageCarmeraUri);
                startActivityForResult(intent,
                        CAMERA_CAPTURE_IMAGE_REQUEST_CODE);

                dialogDelete.dismiss();


            }
        });

        btnUplaodVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent();
                intent.setType("image/*");
                intent.setAction(Intent.ACTION_GET_CONTENT);
                startActivityForResult(
                        Intent.createChooser(intent, "Select Picture"),
                        RESULT_LOAD_IMAGE);
                dialogDelete.dismiss();
            }
        });


        dialogDelete.show();

    }

    void dialogAddVideo() {

        final Dialog dialogDelete = new Dialog(UserUploads.this);

        dialogDelete.requestWindowFeature(Window.FEATURE_NO_TITLE);

        dialogDelete.getWindow().setBackgroundDrawable(
                new ColorDrawable(android.graphics.Color.TRANSPARENT));

        Window window = dialogDelete.getWindow();
        WindowManager.LayoutParams wlp = window.getAttributes();

        wlp.gravity = Gravity.CENTER;
        wlp.flags &= WindowManager.LayoutParams.FLAG_DIM_BEHIND;
        window.setAttributes(wlp);

        dialogDelete.setContentView(R.layout.custom_feedback);

        Button btnUplaodImage = (Button) dialogDelete.findViewById(R.id.btnUplaodImage);
        Button btnUplaodVideo = (Button) dialogDelete.findViewById(R.id.btnUplaodVideo);
        Button btnUplaodRecording = (Button) dialogDelete.findViewById(R.id.btnUplaodRecording);
        btnUplaodRecording.setVisibility(View.GONE);

        btnUplaodImage.setText("Record from camera");
        btnUplaodVideo.setText("Take from gallery");

        btnUplaodImage.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
        btnUplaodVideo.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);

        btnUplaodImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent(MediaStore.ACTION_VIDEO_CAPTURE);
                File mediaStorageDir = new File(Environment
                        .getExternalStorageDirectory(), "/SindhTV/");

                if (mediaStorageDir.exists()) {

                } else {
                    mediaStorageDir.mkdirs();
                }

                String imagePath = Environment.getExternalStorageDirectory()
                        + "/SindhTV/" + System.currentTimeMillis()
                        + ".mp4";
                File carmeraFile = new File(imagePath);
                imageCarmeraUri = Uri.fromFile(carmeraFile);

                intent.putExtra(MediaStore.EXTRA_DURATION_LIMIT, 120);
                intent.putExtra(MediaStore.EXTRA_VIDEO_QUALITY, 0);
                // long maxVideoSize = 512 * 1024 * 1024;
                // intent.putExtra(MediaStore.EXTRA_SIZE_LIMIT, maxVideoSize);

                intent.putExtra(MediaStore.EXTRA_OUTPUT, imageCarmeraUri);
                startActivityForResult(intent, VIDEO_CAPTURE);

                dialogDelete.dismiss();


            }
        });

        btnUplaodVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent = new Intent();
                intent.setType("video/*");
                intent.setAction(Intent.ACTION_GET_CONTENT);
                startActivityForResult(
                        Intent.createChooser(intent, "Select Picture"),
                        RESULT_LOAD_VIDEO_GALLERY);

                dialogDelete.dismiss();
            }
        });


        dialogDelete.show();

    }


    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);

        // save file url in bundle as it will be null on scren orientation
        // changes
        outState.putParcelable("imageCarmeraUri", imageCarmeraUri);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        super.onRestoreInstanceState(savedInstanceState);

        // get the file url
        imageCarmeraUri = savedInstanceState.getParcelable("imageCarmeraUri");
    }


    public static Bitmap RotateBitmap(Bitmap source, float angle) {
        Matrix matrix = new Matrix();
        matrix.postRotate(angle);
        return Bitmap.createBitmap(source, 0, 0, source.getWidth(),
                source.getHeight(), matrix, true);
    }

    private Bitmap decodeFile(File f) {
        try {
            // decode image size
            BitmapFactory.Options o = new BitmapFactory.Options();
            o.inJustDecodeBounds = true;
            BitmapFactory.decodeStream(new FileInputStream(f), null, o);
            // Find the correct scale value. It should be the power of 2.
            final int REQUIRED_SIZE = 70;
            int width_tmp = o.outWidth, height_tmp = o.outHeight;
            int scale = 1;
            while (true) {
                if (width_tmp / 2 < REQUIRED_SIZE
                        || height_tmp / 2 < REQUIRED_SIZE)
                    break;
                width_tmp /= 2;
                height_tmp /= 2;
                scale++;
            }

            // decode with inSampleSize
            BitmapFactory.Options o2 = new BitmapFactory.Options();
            o2.inSampleSize = scale;
            return BitmapFactory.decodeStream(new FileInputStream(f), null, o2);
        } catch (FileNotFoundException e) {
        }
        return null;
    }

    class ImageUpload extends AsyncTask<String, String, String> {

        ProgressDialog progressDialog1 = null;
        String type_id, msg;

        @Override
        protected void onPreExecute() {
            // TODO Auto-generated method stub
            super.onPreExecute();

            progressDialog1 = new ProgressDialog(UserUploads.this);
            progressDialog1.setCancelable(false);
            progressDialog1.setMessage("Uploading...");
            progressDialog1.show();

        }

        @Override
        protected String doInBackground(String... params) {
            // TODO Auto-generated method stub,

            String response = getHTTPResponse(WebServicesUrls.BASE_URL
                    + WebServicesUrls.POST_UPLOAD);

            JSONObject mObject;
            try {
                mObject = new JSONObject(response);

                type_id = mObject.getString("type");
                msg = mObject.getString("response");

            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();

            }

            return null;
        }

        @SuppressLint("NewApi")
        @Override
        protected void onPostExecute(String result) {
            // TODO Auto-generated method stub
            super.onPostExecute(result);

            if (progressDialog1 != null) {
                if (progressDialog1.isShowing()) {
                    progressDialog1.dismiss();
                }
            }

            if (type_id.equals("1")) {

                Toast.makeText(getApplicationContext(), msg, 1000).show();

                startActivity(new Intent(UserUploads.this, UserUploads.class));
                finish();

            } else {

                Toast.makeText(getApplicationContext(), msg, 1000).show();

            }

        }
    }

    public String getHTTPResponse(String url) {
        StringBuilder builder = new StringBuilder();
        HttpClient client = new DefaultHttpClient();

        HttpPost httpPost = new HttpPost(url);


        MultipartEntity entityMultipart = new MultipartEntity(
                HttpMultipartMode.BROWSER_COMPATIBLE);

        try {


            entityMultipart.addPart("name", new StringBody(java.net.URLEncoder.encode(editNameUpload.getText().toString(), "UTF-8")));
            entityMultipart.addPart("message", new StringBody(java.net.URLEncoder.encode(editFeedbackUpload.getText().toString(), "UTF-8")));
            entityMultipart.addPart("email", new StringBody(java.net.URLEncoder.encode(editEmailUpload.getText().toString(), "UTF-8")));
            entityMultipart.addPart("phone", new StringBody(java.net.URLEncoder.encode(editPasswordUpload.getText().toString(), "UTF-8")));

            if (flagType.equals("image")) {
                entityMultipart.addPart("image", new FileBody(new File(
                        path)));

            } else if (flagType.equals("video")) {
                entityMultipart.addPart("file", new FileBody(new File(
                        path)));

            } else if (flagType.equals("audio")) {
                entityMultipart.addPart("audio", new FileBody(new File(
                        path)));

            }


        } catch (UnsupportedEncodingException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }

        httpPost.setEntity(entityMultipart);

        try {
            HttpResponse response = client.execute(httpPost);
            StatusLine statusLine = response.getStatusLine();
            int statusCode = statusLine.getStatusCode();
            if (statusCode == 200 || statusCode == 500) {
                HttpEntity entity = response.getEntity();
                InputStream content = entity.getContent();
                BufferedReader reader = new BufferedReader(
                        new InputStreamReader(content));
                String line;
                while ((line = reader.readLine()) != null) {
                    builder.append(line);
                }
            } else {

            }
        } catch (ClientProtocolException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        String loginResponse = builder.toString();
        return loginResponse;
    }

    @Override
    public boolean onOptionsItemSelected(android.view.MenuItem item) {
        finish();
        return super.onOptionsItemSelected(item);
    }

    void dialogRecord() {

        final Dialog dialog = new android.app.Dialog(UserUploads.this);
        dialog.setTitle("Record Audio");

        dialog.setContentView(com.it.admin.sindhtv.R.layout.record_audio);


        chronometer1 = (android.widget.Chronometer) dialog.findViewById(R.id.chronometer1);
        // store it to sd card


        startBtn = (Button) dialog.findViewById(R.id.start);
        startBtn.setOnClickListener(new android.view.View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                chronometer1.setBase(android.os.SystemClock.elapsedRealtime());
                chronometer1.start();

                start(v);
            }
        });

        stopBtn = (Button) dialog.findViewById(R.id.stop);
        stopBtn.setOnClickListener(new android.view.View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                chronometer1.stop();
                stop(v);
            }
        });

        //playBtn = (Button)dialog. findViewById(R.id.play);
        /*playBtn.setOnClickListener(new android.view.View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                chronometer1.setBase(android.os.SystemClock.elapsedRealtime());
                chronometer1.start();
                play(v);
            }
        });


         stopPlayBtn = (Button)dialog. findViewById(R.id.stopPlay);
        stopPlayBtn.setOnClickListener(new android.view.View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                chronometer1.stop();
                stopPlay(v);
            }
        });*/

        Button done = (Button) dialog.findViewById(com.it.admin.sindhtv.R.id.done);
        done.setOnClickListener(new android.view.View.OnClickListener() {
            @Override
            public void onClick(android.view.View v) {
                btnSelectTypeFeedback.setText("Voice Recorded");
                dialog.dismiss();
            }
        });

        dialog.setOnDismissListener(new android.content.DialogInterface.OnDismissListener() {
            @Override
            public void onDismiss(android.content.DialogInterface dialog) {

            }
        });


        dialog.show();


    }

    public void start(View view) {

        path = Environment.getExternalStorageDirectory()
                .getAbsolutePath() + "/record.3gpp";

        myRecorder = new android.media.MediaRecorder();
        myRecorder.setAudioSource(android.media.MediaRecorder.AudioSource.MIC);
        myRecorder.setOutputFormat(android.media.MediaRecorder.OutputFormat.THREE_GPP);
        myRecorder.setAudioEncoder(android.media.MediaRecorder.OutputFormat.AMR_NB);
        myRecorder.setOutputFile(path);

        try {
            myRecorder.prepare();
            myRecorder.start();
        } catch (IllegalStateException e) {
            // start:it is called before prepare()
            // prepare: it is called after start() or before setOutputFormat()
            e.printStackTrace();
        } catch (IOException e) {
            // prepare() fails
            e.printStackTrace();
        }

        //text.setText("Recording Point: Recording");
        startBtn.setEnabled(false);
        stopBtn.setEnabled(true);

        Toast.makeText(getApplicationContext(), "Start recording...",
                Toast.LENGTH_SHORT).show();
    }

    public void stop(View view) {
        try {
            myRecorder.stop();
            myRecorder.release();
            myRecorder = null;

            stopBtn.setEnabled(false);
            // playBtn.setEnabled(true);
            startBtn.setEnabled(true);
            //text.setText("Recording Point: Stop recording");

            Toast.makeText(getApplicationContext(), "Stop recording...",
                    Toast.LENGTH_SHORT).show();
        } catch (IllegalStateException e) {
            // it is called before start()
            e.printStackTrace();
        } catch (RuntimeException e) {
            // no valid audio/video data has been received
            e.printStackTrace();
        }
    }

    public void play(View view) {
        try {
            myPlayer = new android.media.MediaPlayer();
            myPlayer.setDataSource(path);
            myPlayer.prepare();
            myPlayer.start();

            //playBtn.setEnabled(false);
            // stopPlayBtn.setEnabled(true);
            //	text.setText("Recording Point: Playing");

            Toast.makeText(getApplicationContext(),
                    "Start play the recording...", Toast.LENGTH_SHORT).show();
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public void stopPlay(View view) {
        try {
            if (myPlayer != null) {
                myPlayer.stop();
                myPlayer.release();
                myPlayer = null;
                //  playBtn.setEnabled(true);
                // stopPlayBtn.setEnabled(false);
                startBtn.setEnabled(true);
                //text.setText("Recording Point: Stop playing");

                Toast.makeText(getApplicationContext(),
                        "Stop playing the recording...", Toast.LENGTH_SHORT)
                        .show();
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    private class UploadFileToServer extends AsyncTask<Void, Integer, String> {

        long totalSize = 0;

        @Override
        protected void onPreExecute() {
            // setting progress bar to zero
            progressBarVideoUplaod.setVisibility(View.VISIBLE);
            textLoading.setVisibility(View.VISIBLE);
            progressBarVideoUplaod.setProgress(0);
            super.onPreExecute();
        }

        @Override
        protected void onProgressUpdate(Integer... progress) {
            // Making progress bar visible
            progressBarVideoUplaod.setVisibility(View.VISIBLE);
            textLoading.setVisibility(View.VISIBLE);
            progressBarVideoUplaod.setProgress(progress[0]);

            // updating percentage value
            // txtPercentage.setText(String.valueOf(progress[0]) + "%");
        }

        @Override
        protected String doInBackground(Void... params) {
            return uploadFile();
        }

        @SuppressWarnings("deprecation")
        private String uploadFile() {
            String responseString = null;

            HttpClient httpclient = new DefaultHttpClient();
            HttpPost httppost = new HttpPost(WebServicesUrls.BASE_URL+ WebServicesUrls.POST_UPLOAD+channelID);

            try {
                AndroidMultiPartEntity entity = new AndroidMultiPartEntity(
                        new AndroidMultiPartEntity.ProgressListener() {

                            @Override
                            public void transferred(long num) {
                                publishProgress((int) ((num / (float) totalSize) * 100));
                            }
                        });


                entity.addPart("name", new StringBody(java.net.URLEncoder.encode(editNameUpload.getText().toString(), "UTF-8")));
                entity.addPart("message", new StringBody(java.net.URLEncoder.encode(editFeedbackUpload.getText().toString(), "UTF-8")));
                entity.addPart("email", new StringBody(java.net.URLEncoder.encode(editEmailUpload.getText().toString(), "UTF-8")));
                entity.addPart("phone", new StringBody(java.net.URLEncoder.encode(editPasswordUpload.getText().toString(), "UTF-8")));

                if (flagType.equals("image")) {
                    entity.addPart("image", new FileBody(new File(
                            path)));

                } else if (flagType.equals("video")) {
                    entity.addPart("file", new FileBody(new File(
                            path)));

                } else if (flagType.equals("audio")) {
                    entity.addPart("audio", new FileBody(new File(
                            path)));

                }

                totalSize = entity.getContentLength();
                httppost.setEntity(entity);

                // Making server call
                HttpResponse response = httpclient.execute(httppost);
                HttpEntity r_entity = response.getEntity();

                int statusCode = response.getStatusLine().getStatusCode();
                if (statusCode == 200) {
                    // Server response
                    responseString = EntityUtils.toString(r_entity);
                } else {
                    responseString = "Error occurred! Http Status Code: "
                            + statusCode;
                }

            } catch (ClientProtocolException e) {
                responseString = e.toString();
            } catch (IOException e) {
                responseString = e.toString();
            }

            return responseString;

        }

        @Override
        protected void onPostExecute(String result) {

            try {
                JSONObject jsonObject = new JSONObject(result);


                String   type_id = jsonObject.getString("type");
                String  msg = jsonObject.getString("response");

                Toast.makeText(getApplicationContext(),msg,1000).show();

                progressBarVideoUplaod.setVisibility(View.GONE);
                textLoading.setVisibility(View.GONE);

                showAlert(msg);




            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

            super.onPostExecute(result);
        }

    }

    private void showAlert(String message) {
        AlertDialog.Builder builder = new AlertDialog.Builder(UserUploads.this);
        builder.setMessage(message).setTitle("Response from Servers")
                .setCancelable(false)
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        // do nothing
                    }
                });
        AlertDialog alert = builder.create();
        alert.show();
    }

    void dialog(){

        AlertDialog alertDialog = new AlertDialog.Builder(
                UserUploads.this).create();

        // Setting Dialog Title
        alertDialog.setTitle("Upload");

        // Setting Dialog Message
        alertDialog.setMessage("Successfully Uploaded!");
        // Setting Icon to Dialog
       // alertDialog.setIcon(R.drawable.tick);

        // Setting OK Button
        alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                // Write your code here to execute after dialog closed


                startActivity(new Intent(UserUploads.this,UserUploads.class));
                finish();


            }
        });

        // Showing Alert Message
        alertDialog.show();

    }


}
