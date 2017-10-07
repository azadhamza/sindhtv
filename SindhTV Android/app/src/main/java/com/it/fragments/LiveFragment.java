package com.it.fragments;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.it.admin.sindhtv.PlayerMain;
import com.it.admin.sindhtv.R;
import com.it.utility.ServiceHandler;
import com.it.utility.WebServicesUrls;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by admin on 4/15/2016.
 */
public class LiveFragment extends Fragment {

    private String channelID;
    private SharedPreferences shp;
    private ImageView imageWatchLive, imageListenLive;
    private String webview_url,audio_url;
    private boolean isFirstTime = true;
    private LinearLayout topLayoutLive;

    public static LiveFragment newInstance(Bundle bundle) {
        LiveFragment fragment = new LiveFragment();
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // listView = new ListView(getActivity());
        isFirstTime = false;
        View fakeHeader = inflater.inflate(R.layout.subscription_fragment, null);

        shp = getActivity().getSharedPreferences("sindhtv", 0);
        String bg = shp.getString("bg_color", "");
        channelID = shp.getString("channel_id", "");


        String rsult = "-"+15.033f;
        float data = Float.parseFloat(rsult);

        new GetVideoURL().execute();

        imageWatchLive = (ImageView) fakeHeader.findViewById(R.id.imageWatchLive);

        imageListenLive = (ImageView)fakeHeader.findViewById(R.id.imageListenLive);

          topLayoutLive = (LinearLayout) fakeHeader.findViewById(R.id.topLayoutLive);
        if(channelID.equals("29") || channelID.equals("58")){
            topLayoutLive.setBackgroundResource(R.drawable.gray_bg);
        }else{
            topLayoutLive.setBackgroundResource(R.drawable.orange_bg);
        }
        
       /* Picasso.with(getActivity()).load(bg).into(new Target() {
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
        });*/

        imageWatchLive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String url = webview_url;
                shp.edit().putString("url", url).commit();

                startActivity(new Intent(getActivity(), PlayerMain.class));
            }
        });

        imageListenLive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                String url = audio_url;
                shp.edit().putString("url", url).commit();

                startActivity(new Intent(getActivity(), PlayerMain.class));


            }
        });

        return fakeHeader;
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        // TODO Auto-generated method stub
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            if(channelID.equals("29") || channelID.equals("58")){
                topLayoutLive.setBackgroundResource(R.drawable.gray_bg_land);
            }else{
                topLayoutLive.setBackgroundResource(R.drawable.orange_bg_land);
            }
        } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
            if(channelID.equals("29") || channelID.equals("58")){
                topLayoutLive.setBackgroundResource(R.drawable.gray_bg);
            }else{
                topLayoutLive.setBackgroundResource(R.drawable.orange_bg);
            }
        }
    }

    private class GetVideoURL extends AsyncTask<Void, Void, Void> {

        //private ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

       //     progressDialog = new ProgressDialog(getActivity());
        //    progressDialog.setMessage("Loading...");
        //    progressDialog.setCancelable(false);
        //    progressDialog.show();

        }

        @Override
        protected Void doInBackground(Void... params) {

            String url = WebServicesUrls.BASE_URL + WebServicesUrls.GET_LIVES + channelID + "/1";

            ServiceHandler service = new ServiceHandler();

            final String jsonStr = service.makeServiceCall(url,
                    ServiceHandler.GET);

            try {
                JSONObject jsonobject = new JSONObject(jsonStr);
                JSONArray jsonArrayMian = jsonobject.getJSONArray("items");

                for (int j = 0; j < jsonArrayMian.length(); j++) {

                    JSONObject jsonobject2 = jsonArrayMian.getJSONObject(j);

                     webview_url = jsonobject2.getString("webview_url");

                    audio_url = jsonobject2.getString("audio_url");

                }


            } catch (JSONException e) {
                Log.e("Error", e.getMessage());
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Void result) {
            // TODO Auto-generated method stub

            super.onPostExecute(result);

          //  if (progressDialog.isShowing()) {
          //      progressDialog.dismiss();
          //  }


        }
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (!isFirstTime) {
                new com.it.fragments.LiveFragment.GetVideoURL().execute();
            }
        } else {

        }
    }

}
