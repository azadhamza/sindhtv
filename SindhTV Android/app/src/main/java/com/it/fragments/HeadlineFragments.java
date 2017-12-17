package com.it.fragments;

import android.app.FragmentManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.it.adapter.MainCategoriesAdapter;
import com.it.admin.sindhtv.PlayerMain;
import com.it.admin.sindhtv.R;
import com.it.utility.GetterSetter;
import com.it.utility.GlobalArraylist;
import com.it.utility.ServiceHandler;
import com.it.utility.WebServicesUrls;
import com.squareup.picasso.Picasso;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by admin on 4/21/2016.
 */
public class HeadlineFragments  extends Fragment {

    private ProgressBar progressRecent;
    int page = 1;
    String totalPages;
    int count = 0;
    private boolean isLoadedFirstTime = true;
    boolean flag = false;
    private View mFooter;
    // CustomAdapter adapter;
    private static final String TAG = "PagerFragment";
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private int params;
    private ListView listView;
    SharedPreferences shp;
    BroadcastReceiver mRegistrationBroadcastReceiver;
    private List<String> listDataHeader;

    CustomAdapterList adapter1;
    CustomAdapterGallery adapterGallery;
    MainCategoriesAdapter adapter;
    Boolean isInternetPresent = false;
    private android.widget.TextView textNothingHereArticle;
    private boolean isFirstTime = true;
    private RelativeLayout topLayoutLive;
    private String channelID, videoChnnelClicked, appId;

    public static HeadlineFragments newInstance(Bundle bundle) {
        HeadlineFragments fragment = new HeadlineFragments();
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
        View view = inflater.inflate(R.layout.fragment_headlines, container,
                false);
        GlobalArraylist.arrHeadlinesVideosFinal.clear();
        GlobalArraylist.arrHeadlinesVideos.clear();

        shp = getActivity().getSharedPreferences("sindhtv", 0);
        String bg = shp.getString("bg_color", "");
        channelID = shp.getString("channel_id", "");
        videoChnnelClicked = shp.getString("videoChnnel_clicked", "");
        appId = shp.getString("application_id", "");

        listDataHeader = new ArrayList<String>();
        //listChannelId = new ArrayList<String>();

          topLayoutLive = (RelativeLayout) view.findViewById(R.id.relativeVideoListHealine);
        if(channelID.equals("3") || channelID.equals("1")){
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


        listView = (ListView) view.findViewById(R.id.listVideoChannelListHealine);

        progressRecent = (ProgressBar) view.findViewById(R.id.progressVideoChannelListHealine);
        textNothingHereArticle = (android.widget.TextView)view.findViewById(R.id.textNothingHereHeadLines);

        new GetLiveHomeVideos().execute();

        onBack();

        return view;
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        // TODO Auto-generated method stub
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            if(channelID.equals("3") || channelID.equals("1")){
                topLayoutLive.setBackgroundResource(R.drawable.gray_bg_land);
            }else{
                topLayoutLive.setBackgroundResource(R.drawable.orange_bg_land);
            }
        } else if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
            if(channelID.equals("3") || channelID.equals("1")){
                topLayoutLive.setBackgroundResource(R.drawable.gray_bg);
            }else{
                topLayoutLive.setBackgroundResource(R.drawable.orange_bg);
            }
        }
    }

    public void onBack() {

        FragmentManager g = getActivity().getFragmentManager();

        g.popBackStack();
    }

    private class GetLiveHomeVideos extends AsyncTask<Void, Void, Void> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressRecent.setVisibility(View.VISIBLE);

        }

        @Override
        protected Void doInBackground(Void... params) {

            String url = WebServicesUrls.BASE_URL + WebServicesUrls.GET_HEADLINES + channelID;

            ServiceHandler service = new ServiceHandler();

            final String jsonStr = service.makeServiceCall(url,
                    ServiceHandler.GET);

            try {

                GlobalArraylist.arrHeadlinesVideos
                        .clear();
                GlobalArraylist.arrHeadlinesVideosFinal
                        .clear();

                JSONObject jsonObjectRoot = new JSONObject(jsonStr);

                JSONArray jsonArrayMian = jsonObjectRoot.getJSONArray("items");

                listDataHeader.clear();

                for (int j = 0; j < jsonArrayMian.length(); j++) {

                    JSONObject jsonobject2 = jsonArrayMian.getJSONObject(j);

                    String catName = jsonobject2.getString("schedule_name");
                    // String channelId = jsonobject2.getString("schedule_id");

                    listDataHeader.add(catName);
                    //   listChannelId.add(channelId);


                    JSONArray jsonArray = jsonobject2.getJSONArray("videos");

                    ArrayList<GetterSetter> localArrayList = new ArrayList<GetterSetter>();
                    for (int i = 0; i < jsonArray.length(); i++) {

                        JSONObject jsonObject = jsonArray.getJSONObject(i);

                        String videoId = jsonObject.getString("videoid");
                        String smallTitle = jsonObject.getString("title");
                        //String fullTitle = jsonObject.getString("full_title");
                        String urlVideo = jsonObject.getString("webview_url");
                        //	String watched = jsonObject.getString("watched");
                        //	String liked = jsonObject.getString("liked");
                        //	String wlater = jsonObject.getString("wlater");
                        String thumb = jsonObject.getString("thumb");
                        String duration = jsonObject.getString("duration");
                        //	String userLink = jsonObject.getString("user-link");
                        //	String userName = jsonObject.getString("user-name");
                        String views = jsonObject.getString("views");
                        String timeAgo = jsonObject.getString("time-ago");


                        localArrayList.add(new GetterSetter(videoId,
                                smallTitle, "", urlVideo, "",
                                "", "", thumb, duration, "",
                                "", views, timeAgo));

                    }

                    GlobalArraylist.arrHeadlinesVideosFinal
                            .add(localArrayList);

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

            progressRecent.setVisibility(View.GONE);
            // listView.setAdapter(new CustomAdapter());
            // expandableListView.setAdapter(adapter);
            listView.setAdapter(new CustomAdapterList());
            if( listDataHeader.size() == 0){

                textNothingHereArticle.setVisibility(android.view.View.VISIBLE);
                listView.setVisibility(android.view.View.GONE);

            }else{
                textNothingHereArticle.setVisibility(android.view.View.GONE);
                listView.setVisibility(android.view.View.VISIBLE);


            }


        }
    }

    class CustomAdapterList extends BaseAdapter {

        @Override
        public int getCount() {
            // TODO Auto-generated method stub
            return listDataHeader.size();
        }

        @Override
        public Object getItem(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        @Override
        public long getItemId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        @Override
        public View getView(final int position, View view1, ViewGroup arg2) {
            // TODO Auto-generated method stub

            LayoutInflater inflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View view = inflater.inflate(R.layout.gallery_view, null);

            TextView textTitleCats = (TextView) view
                    .findViewById(R.id.textTitleCats);

            // int sizeTest = GlobalArraylist.arrHeadlinesVideosFinal.get(position)
            // .size();

            Gallery gallery = (Gallery) view.findViewById(R.id.gallery1);


            gallery.setFadingEdgeLength(0);
            textTitleCats.setText(listDataHeader.get(position));

            // for (int i = 0; i < listDataHeader.size(); i++) {

            // int mPosition = position;
            adapterGallery = new CustomAdapterGallery(
                    position,
                    GlobalArraylist.arrHeadlinesVideosFinal
                            .get(position));

            // String finalName =
            // GlobalArraylist.arrHeadlinesVideosFinal.get(position)
            // .get(0)._smallTitle;

            gallery.setAdapter(adapterGallery);

            gallery.setOnItemClickListener(new AdapterView.OnItemClickListener() {

                @Override
                public void onItemClick(AdapterView<?> arg0, View arg1,
                                        int positionGallery, long arg3) {
                    // TODO Auto-generated method stub


                    String url = GlobalArraylist.arrHeadlinesVideosFinal
                            .get(position).get(positionGallery)._urlVideo;

                    shp.edit().putString("url", url).commit();

                    startActivity(new Intent(getActivity(), PlayerMain.class));

                  /*  WebviewHealinesFragment videoListChannelsFragment = new WebviewHealinesFragment();
                    getFragmentManager().beginTransaction()
                            .replace(R.id.fragmentReplaceHealine, videoListChannelsFragment)
                            .addToBackStack(null)
                            .commit();*/

                }
            });

            // }

            return view;
        }

    }

    class CustomAdapterGallery extends BaseAdapter {
        int pos;
        ArrayList<GetterSetter> currentList;

        public CustomAdapterGallery(int pos, ArrayList<GetterSetter> currentList) {
            // TODO Auto-generated constructor stub
            this.pos = pos;
            this.currentList = currentList;
            System.out.println(currentList.get(0)._smallTitle);
        }

        @Override
        public int getCount() {
            return currentList.size();
        }

        @Override
        public Object getItem(int position) {
            return position;
        }

        @Override
        public long getItemId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        @Override
        public View getView(int position, View view1, ViewGroup arg2) {
            // TODO Auto-generated method stub

            LayoutInflater inflater = (LayoutInflater) getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View view = inflater.inflate(R.layout.custom_gallery, null);

            ImageView imageVideoAccount = (ImageView) view
                    .findViewById(R.id.imageVideoGallery);

            TextView textVideo = (TextView) view
                    .findViewById(R.id.textVideoGallery);

            TextView textTime = (TextView) view
                    .findViewById(R.id.textTimeGallery);
            TextView textVideoLives = (TextView) view
                    .findViewById(R.id.textVideoLives1);
            //	TextView textVideoBy = (TextView) view
            //	.findViewById(R.id.textVideoByGallery);

            // Log.e("Child====", "" + currentList.get(position)._smallTitle);

            textVideo.setText(currentList.get(position)._smallTitle);

            if (currentList.get(position)._thumb != null && !currentList.get(position)._thumb.isEmpty()) {
                Picasso.with(getActivity())
                        .load(currentList.get(position)._thumb)
                        .placeholder(R.drawable.black)
                        .into(imageVideoAccount);
            }

            textTime.setText(currentList.get(position)._duration);
            //	textVideoBy.setText(currentList.get(position)._userName);
            // textVideoLives.setText(currentList.get(position)._thumb);

            return view;
        }
    }

    /*@Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // TODO Auto-generated method stub

        getMenuInflater().inflate(R.menu.main, menu);

        MenuItem menuItemReferesh = menu.findItem(R.id.menu_referesh);
        MenuItem menuItemFeedback = menu.findItem(R.id.menu_feedback);

        menuItemReferesh
                .setOnMenuItemClickListener(new OnMenuItemClickListener() {

                    @Override
                    public boolean onMenuItemClick(MenuItem item) {
                        // TODO Auto-generated method stub

                        startActivity(new Intent(getActivity(),
                                MainActivity.class));
                        getActivity().finish();

                        return true;
                    }
                });

        menuItemFeedback
                .setOnMenuItemClickListener(new OnMenuItemClickListener() {

                    @Override
                    public boolean onMenuItemClick(MenuItem arg0) {
                        // TODO Auto-generated method stub
                        startActivity(new Intent(getActivity(),
                                FeedbackActivity.class));
                        return true;
                    }
                });
        return true;
    }
*/
    public Bitmap getBitmapFromURL(String imageUrl) {
        try {
            URL url = new URL(imageUrl);
            HttpURLConnection connection = (HttpURLConnection) url
                    .openConnection();
            connection.setDoInput(true);
            connection.connect();
            InputStream input = connection.getInputStream();
            Bitmap myBitmap = BitmapFactory.decodeStream(input);
            return myBitmap;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public int getScreenOrientation() {
        Display getOrient = getActivity().getWindowManager().getDefaultDisplay();
        int orientation = Configuration.ORIENTATION_UNDEFINED;
        if (getOrient.getWidth() == getOrient.getHeight()) {
            orientation = Configuration.ORIENTATION_SQUARE;
        } else {
            if (getOrient.getWidth() < getOrient.getHeight()) {
                orientation = Configuration.ORIENTATION_PORTRAIT;
            } else {
                orientation = Configuration.ORIENTATION_LANDSCAPE;
            }
        }
        return orientation;
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (!isFirstTime) {
                new GetLiveHomeVideos().execute();
            }
        } else {

        }
    }

}
