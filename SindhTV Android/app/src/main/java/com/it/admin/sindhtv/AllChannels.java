package com.it.admin.sindhtv;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.StrictMode;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.it.utility.GetterSetter;
import com.it.utility.GlobalArraylist;
import com.it.utility.ServiceHandler;
import com.it.utility.WebServicesUrls;
import com.squareup.picasso.Picasso;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

/**
 * Created by admin on 4/19/2016.
 */
public class AllChannels extends AppCompatActivity {

    android.content.BroadcastReceiver mRegistrationBroadcastReceiver;

    private GridView gridAllChannels;
    private ProgressBar progressChannels;
    private SharedPreferences shp;
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private RelativeLayout relativeAllChannels;
    private ImageView imageBackAllChannels;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.all_channels);

        getSupportActionBar().hide();

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder()
                .permitAll().build();
        StrictMode.setThreadPolicy(policy);


        if (isNetworkAvailable(AllChannels.this)) {
            // code here


        mRegistrationBroadcastReceiver = new android.content.BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {

                SharedPreferences sharedPreferences = android.preference.PreferenceManager
                        .getDefaultSharedPreferences(context);
                boolean sentToken = sharedPreferences.getBoolean(
                        QuickstartPreferences.SENT_TOKEN_TO_SERVER, false);
                if (sentToken) {
                    // mInformationTextView.setText(getString(R.string.gcm_send_message));
                } else {
                    // mInformationTextView.setText(getString(R.string.token_error_message));
                }
            }
        };

        if (checkPlayServices()) {
            // Start IntentService to register this application with GCM.
            Intent intent = new Intent(this, RegistrationIntentService.class);
            startService(intent);
        } else {
            Toast.makeText(getApplicationContext(), "No Play Services Found",
                    Toast.LENGTH_SHORT).show();
        }



        shp = getSharedPreferences("sindhtv", 0);

        init();

        new GetChannels().execute();
        GlobalArraylist.arrChannels.clear();

        GlobalArraylist.arrChannels.add(new GetterSetter("2", "Sindh TV", R.drawable.sindhtv));
        GlobalArraylist.arrChannels.add(new GetterSetter("3", "Sindh TV News", R.drawable.sindhtv_news));
        GlobalArraylist.arrChannels.add(new GetterSetter("1", "Daily Jeejal", R.drawable.jeejal));

        gridAllChannels.setAdapter(new CustomChannelsAdapter());

        gridAllChannels.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                shp.edit().putString("channel_id", GlobalArraylist.arrChannels.get(position)._id).putInt("channel_image", GlobalArraylist.arrChannels.get(position)._imageSel).commit();
                startActivity(new Intent(AllChannels.this, MainActivity.class));

            }
        });

        } else {
            Toast.makeText(AllChannels.this, R.string.no_internet_msg, Toast.LENGTH_LONG).show();
//            finish();
        }


    }


    void init() {

        imageBackAllChannels = (ImageView)findViewById(R.id.imageBackAllChannels);
         relativeAllChannels = (RelativeLayout)findViewById(R.id.relativeAllChannels);

        gridAllChannels = (GridView) findViewById(R.id.gridAllChannels);
        progressChannels = (ProgressBar) findViewById(R.id.progressChannels);

    }

    @Override
    protected void onResume() {
        super.onResume();

        android.support.v4.content.LocalBroadcastManager.getInstance(this).registerReceiver(
                mRegistrationBroadcastReceiver,
                new android.content.IntentFilter(QuickstartPreferences.REGISTRATION_COMPLETE));
    }

    @Override
    protected void onPause() {
        android.support.v4.content.LocalBroadcastManager.getInstance(this).unregisterReceiver(
                mRegistrationBroadcastReceiver);
        super.onPause();
    }

    private class GetChannels extends AsyncTask<Void, Void, Void> {

        String application_bg;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressChannels.setVisibility(View.VISIBLE);

        }

        @Override
        protected Void doInBackground(Void... params) {

            String url = WebServicesUrls.BASE_URL + WebServicesUrls.GET_CHANNELS;

            ServiceHandler service = new ServiceHandler();

            final String jsonStr = service.makeServiceCall(url,
                    ServiceHandler.GET);

            try {

               // GlobalArraylist.arrChannels.clear();

                JSONObject jsonobject = new JSONObject(jsonStr);
              //  JSONArray jsonArrayMian = jsonobject.getJSONArray("items");

               /* for (int j = 0; j < jsonArrayMian.length(); j++) {

                    JSONObject jsonobject2 = jsonArrayMian.getJSONObject(j);

                    String channel_id = jsonobject2.getString("channel_id");
                    String channel_thumb = jsonobject2.getString("channel_thumb");
                    String channel_name = jsonobject2.getString("channel_name");

                    GlobalArraylist.arrChannels.add(new GetterSetter(channel_id, channel_name, channel_thumb));

                }*/

                JSONObject jsonApplication = jsonobject.getJSONObject("application");

                String application_id = jsonApplication.getString("application_id");
                 application_bg = jsonApplication.getString("application_bg");
                String menu_bgcolr = jsonApplication.getString("menu_bgcolr");
                String menu_scolor = jsonApplication.getString("menu_scolor");
                String menu_ucolor = jsonApplication.getString("menu_ucolor");
                String menu_acolor = jsonApplication.getString("menu_acolor");
                String list_bgcolor = jsonApplication.getString("list_bgcolor");
                String menu_tcolor = jsonApplication.getString("menu_tcolor");
                String list_tcolor = jsonApplication.getString("list_tcolor");
                String banner_code_ios = jsonApplication.getString("banner_code_ios");
                String interstitial_code_ios = jsonApplication.getString("interstitial_code_ios");


                shp.edit().putString("application_id", application_id).putString("bg_color", application_bg)
                        .putString("tabbg_color", menu_bgcolr)
                        .putString("tabseperator_color", menu_scolor)
                        .putString("tabunderline_color", menu_ucolor)
                        .putString("actionbar_color", menu_acolor)
                        .putString("listbg_color", list_bgcolor)
                        .putString("tabtext_color", menu_tcolor)
                        .putString("listtext_color", list_tcolor)
                        .putString("banner_code_ios", banner_code_ios)
                        .putString("interstitial_code_ios", interstitial_code_ios).commit();


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

            progressChannels.setVisibility(View.GONE);

          /*  if ( application_bg.equals("")) {

            } else {

                try {
                    Picasso.with(AllChannels.this).load(application_bg).into(imageBackAllChannels);
                }catch (Exception e){

                }
            }


            gridAllChannels.setAdapter(new CustomChannelsAdapter());
*/
/*            String banner_code_ios = shp.getString("banner_code_ios","");

            android.widget.LinearLayout adContainer = (android.widget.LinearLayout)findViewById(com.it.admin.sindhtv.R.id.linearAdAllChannels);
            com.google.android.gms.ads.AdView adView = new com.google.android.gms.ads.AdView(com.it.admin.sindhtv.AllChannels.this);
            adView.setAdSize(com.google.android.gms.ads.AdSize.SMART_BANNER);
            adView.setAdUnitId(banner_code_ios);

// Initiate a generic request to load it with an ad
            com.google.android.gms.ads.AdRequest adRequest = new com.google.android.gms.ads.AdRequest.Builder().build();

            adView.loadAd(adRequest);

            android.widget.LinearLayout.LayoutParams params = new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.MATCH_PARENT);
            adContainer.addView(adView, params);*/

        }
    }

    private class CustomChannelsAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            return GlobalArraylist.arrChannels.size();
        }

        @Override
        public Object getItem(int position) {
            return position;
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {

            LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);

            View view = layoutInflater.inflate(R.layout.custom_channels, null);


            ImageView roundImage = (ImageView) view.findViewById(R.id.imageUser);
            TextView textChannelName = (TextView) view.findViewById(R.id.textChannelName);


         /*   URL url1 = null;
            Bitmap largeIcon = null;
            try {
                url1 = new URL(GlobalArraylist.arrChannels.get(position)._image);
                try {
                    largeIcon = BitmapFactory.decodeStream(url1
                            .openConnection().getInputStream());
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }

            } catch (MalformedURLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }*/

         /*   try {
                if (GlobalArraylist.arrChannels.get(position)._image.equals("")) {

                } else {

                    URL url = null;
                    try {
                        url = new URL(GlobalArraylist.arrChannels.get(position)._image);

                        URI uri = null;
                        try {
                            uri = new URI(url.getProtocol(),
                                    url.getUserInfo(), url.getHost(),
                                    url.getPort(), url.getPath(),
                                    url.getQuery(), url.getRef());
                        } catch (URISyntaxException e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                        }
                        url = uri.toURL();
                    } catch (MalformedURLException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    String p = url.toString();

                    if (p == null) {

                    } else {

                        Picasso.with(AllChannels.this).load(p)
                                .into(roundImage);
                    }
                }
            }catch (Exception e){

            }*/
            Picasso.with(AllChannels.this).load(GlobalArraylist.arrChannels.get(position)._imageSel).into(roundImage);
            textChannelName.setText(GlobalArraylist.arrChannels.get(position)._name);


            return view;
        }
    }
    private boolean checkPlayServices() {
        int resultCode = GooglePlayServicesUtil
                .isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (GooglePlayServicesUtil.isUserRecoverableError(resultCode)) {
                GooglePlayServicesUtil.getErrorDialog(resultCode, this,
                        PLAY_SERVICES_RESOLUTION_REQUEST).show();
            } else {
                //Log.i(TAG, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }

    public boolean isNetworkAvailable(final Context context) {
        final ConnectivityManager connectivityManager = ((ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE));
        return connectivityManager.getActiveNetworkInfo() != null && connectivityManager.getActiveNetworkInfo().isConnected();
    }

}
