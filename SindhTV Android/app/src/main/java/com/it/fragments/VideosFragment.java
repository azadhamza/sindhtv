package com.it.fragments;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.it.admin.sindhtv.R;
import com.it.utility.GetterSetter;
import com.it.utility.GlobalArraylist;
import com.it.utility.RoundedImageView;
import com.it.utility.ServiceHandler;
import com.it.utility.WebServicesUrls;
import com.squareup.picasso.Picasso;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

/**
 * Created by admin on 4/21/2016.
 */
public class VideosFragment extends Fragment {

    private String channelID, appId;
    private SharedPreferences shp;
    private GridView gridVideosCats;
    private ProgressBar progressVideoCats;
    private android.widget.TextView textNothingHereArticle;
    private boolean isFirstTime = true;
    private RelativeLayout topLayoutLive;


    public static VideosFragment newInstance(Bundle bundle) {
        VideosFragment fragment = new VideosFragment();
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
        View fakeHeader = inflater.inflate(R.layout.fragment_video, null);
        shp = getActivity().getSharedPreferences("sindhtv", 0);
        String bg = shp.getString("bg_color", "");
        channelID = shp.getString("channel_id", "");
        appId = shp.getString("application_id", "");

        gridVideosCats = (GridView) fakeHeader.findViewById(R.id.gridVideosCats);
        textNothingHereArticle = (android.widget.TextView)fakeHeader.findViewById(R.id.textNothingHereVideos);


        progressVideoCats = (ProgressBar) fakeHeader.findViewById(R.id.progressVideoCats);

          topLayoutLive = (RelativeLayout) fakeHeader.findViewById(R.id.topLayoutVideo);
        if(channelID.equals("29") || channelID.equals("58")){
            topLayoutLive.setBackgroundResource(R.drawable.gray_bg);
        }else{
            topLayoutLive.setBackgroundResource(R.drawable.orange_bg);
        }
       /* if (bg.equals("")) {

        } else {
            Picasso.with(getActivity()).load(bg).into(new Target() {
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
        }*/

        new GetVideoChannels().execute();

        gridVideosCats.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {


                shp.edit().putString("videoChnnel_clicked", GlobalArraylist.arrVideoCategories.get(position)._id).commit();


                VideoListChannelsFragment videoListChannelsFragment = new VideoListChannelsFragment();
                getFragmentManager().beginTransaction()
                        .replace(R.id.fragmentReplace, videoListChannelsFragment)
                        .addToBackStack(null)
                        .commit();


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

    private class GetVideoChannels extends AsyncTask<Void, Void, Void> {


        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressVideoCats.setVisibility(View.VISIBLE);
        }

        @Override
        protected Void doInBackground(Void... params) {

            String url = WebServicesUrls.BASE_URL + WebServicesUrls.GET_VIDEO_CATEGORY + channelID;

            ServiceHandler service = new ServiceHandler();

            final String jsonStr = service.makeServiceCall(url,
                    ServiceHandler.GET);

            GlobalArraylist.arrVideoCategories.clear();

            try {
                JSONObject jsonobject = new JSONObject(jsonStr);
                JSONArray jsonArrayMian = jsonobject.getJSONArray("items");

                for (int j = 0; j < jsonArrayMian.length(); j++) {

                    JSONObject jsonobject2 = jsonArrayMian.getJSONObject(j);

                    String menu_id = jsonobject2.getString("menu_id");
                    String menu_icon = jsonobject2.getString("menu_icon");
                    String menu_name = jsonobject2.getString("menu_name");

                    GlobalArraylist.arrVideoCategories.add(new GetterSetter(menu_id, menu_name, menu_icon,""));


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

            progressVideoCats.setVisibility(View.GONE);


            gridVideosCats.setAdapter(new CustomVideoCatsAdapter());
            if( GlobalArraylist.arrVideoCategories.size() == 0){

                textNothingHereArticle.setVisibility(android.view.View.VISIBLE);
                gridVideosCats.setVisibility(android.view.View.GONE);

            }else{
                textNothingHereArticle.setVisibility(android.view.View.GONE);
                gridVideosCats.setVisibility(android.view.View.VISIBLE);


            }


        }

        private class CustomVideoCatsAdapter extends BaseAdapter {

            @Override
            public int getCount() {
                return GlobalArraylist.arrVideoCategories.size();
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

                LayoutInflater layoutInflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

                View view = layoutInflater.inflate(R.layout.custom_video, null);


                RoundedImageView roundImage = (RoundedImageView) view.findViewById(R.id.imageUser1);
                TextView textChannelName = (TextView) view.findViewById(R.id.textChannelName1);


                URL url1 = null;
                Bitmap largeIcon = null;
                try {
                    url1 = new URL(GlobalArraylist.arrVideoCategories.get(position)._image);
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
                }

                if (GlobalArraylist.arrVideoCategories.get(position)._image.equals("")) {

                } else {

                    URL url = null;
                    try {
                        url = new URL(GlobalArraylist.arrVideoCategories.get(position)._image);

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

                        Picasso.with(getActivity()).load(p).resize(100, 100)
                                .into(roundImage);
                    }
                }

                textChannelName.setText(GlobalArraylist.arrVideoCategories.get(position)._name);


                return view;
            }
        }

    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (!isFirstTime) {
                new com.it.fragments.VideosFragment.GetVideoChannels().execute();
            }
        } else {

        }
    }

}

