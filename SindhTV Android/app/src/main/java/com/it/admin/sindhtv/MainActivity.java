package com.it.admin.sindhtv;

import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.ads.AdView;
import com.it.fragments.ArticleFragment;
import com.it.fragments.EPaperFragent;
import com.it.fragments.HeadlineFragments;
import com.it.fragments.LiveFragment;
import com.it.fragments.VideosFragment;
import com.it.pagerstrips.PagerSlidingTabStrip;
import com.it.utility.ConnectionDetector;
import com.it.utility.PagerFragment;
import com.it.utility.ServiceHandler;
import com.it.utility.WebServicesUrls;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {

    int RESULT_LOAD_IMAGE1 = 1234;
    private ViewPager mPager;
    private ViewPagerAdapter mPagerAdapter;
    private PagerSlidingTabStrip mTabStrip;
    private RelativeLayout mTopView;
    int[] tabtitles1;

    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;
    private String mTitle = "Poovee", key = "";
    private String[] items;
    String path = "";
    private int[] images;
    private int selectedPosition;
    // private TextView textTitle;
    BroadcastReceiver mRegistrationBroadcastReceiver;
    private ArrayList<Integer> arrMenuId = new ArrayList<Integer>();
    private ArrayList<String> arrMenuImage = new ArrayList<String>();
    private ArrayList<String> arrMenuName = new ArrayList<String>();
    private ArrayList<String> arrMenuNameTabs = new ArrayList<String>();
    private ArrayList<String> arrMenuCheckMenuType = new ArrayList<String>();
    private ArrayList<Integer> arrMenuIdTabs = new ArrayList<Integer>();

    //SharedPreferences shp;
    Boolean isInternetPresent = false;
    public static FloatingActionButton fab;
    private SharedPreferences shp;
    Menu menuTop;
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    // TextView textTitleHome;
    private String channelID, bgColor, tabBgColor, tabSepColor, tabUnderColor, actionbarColor, listBgColor, tabTextColor, listTextColor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder()
                .permitAll().build();
        StrictMode.setThreadPolicy(policy);

        final ActionBar actionBar = getSupportActionBar();

        LayoutInflater mInflater = LayoutInflater.from(this);
        View mCustomView = mInflater.inflate(R.layout.custom_action_bar_back, null);
        ActionBar.LayoutParams paramsn = new ActionBar.LayoutParams(//Center the textview in the ActionBar !
                ActionBar.LayoutParams.WRAP_CONTENT,
                ActionBar.LayoutParams.MATCH_PARENT,
                Gravity.CENTER);
        ImageView image_logo = (ImageView) mCustomView.findViewById(R.id.image_logo);

        getSupportActionBar().setCustomView(mCustomView, paramsn);
        getSupportActionBar().setCustomView(mCustomView);
        getSupportActionBar().setDisplayShowCustomEnabled(true);

        ConnectionDetector cd = new ConnectionDetector(getApplicationContext());

        isInternetPresent = cd.isConnectingToInternet();

        // check for Internet status
        if (isInternetPresent) {

        } else {
            Toast.makeText(getApplicationContext(),
                    "No Internet Connection Found!", Toast.LENGTH_SHORT).show();
            finish();
        }


// Place the ad view.

      /*  AdView mAdView = (com.google.android.gms.ads.AdView)findViewById(R.id.adViewMainTab);
        mAdView.setAdSize(com.google.android.gms.ads.AdSize.SMART_BANNER);
        mAdView.setAdUnitId("/104753804/Mobile_Banner");
      //  adContainer.addView(mAdView);
        com.google.android.gms.ads.AdRequest adRequest = new com.google.android.gms.ads.AdRequest.Builder().build();
        mAdView.loadAd(adRequest);*/

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

        android.widget.LinearLayout adContainer = (android.widget.LinearLayout) findViewById(R.id.layoutAdsMain);
        AdView adView = new AdView(MainActivity.this);
        adView.setAdSize(com.google.android.gms.ads.AdSize.SMART_BANNER);
        adView.setAdUnitId(banner_code_ios);

// Initiate a generic request to load it with an ad
        com.google.android.gms.ads.AdRequest adRequest = new com.google.android.gms.ads.AdRequest.Builder().build();

        adView.loadAd(adRequest);

        android.widget.LinearLayout.LayoutParams params = new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.MATCH_PARENT);
        adContainer.addView(adView, params);


        init();


        actionBar.setBackgroundDrawable(new ColorDrawable(Color.parseColor(actionbarColor)));
        actionBar.setDisplayShowTitleEnabled(false);


        actionBar.setDisplayUseLogoEnabled(true);
        actionBar.setDisplayShowHomeEnabled(true);

        // Getting reference to the DrawerLayout
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerList = (ListView) findViewById(R.id.drawer_list);

        mDrawerList.setBackgroundColor(Color.parseColor(listBgColor));


        shp = getSharedPreferences("sindhtv", 0);

        String channel_id = shp.getString("channel_id", "");

        if (channel_id.equals("2")) {
            image_logo.setBackgroundResource(R.drawable.sindhtv);
            // actionBar.setLogo(R.drawable.sindhtv);
        } else if (channel_id.equals("3")) {
            image_logo.setBackgroundResource(R.drawable.sindhtv_news);
            //actionBar.setLogo(R.drawable.sindhtv_news);
        } else {
            image_logo.setBackgroundResource(R.drawable.jeejal);
            //actionBar.setLogo(R.drawable.jeejal);
        }

        // String logoUrl = shp.getString("channel_image", "");



      /*  if (logoUrl.equals("")) {

        } else {
            Picasso.with(MainActivity.this).load(logoUrl).into(new Target() {
                @Override
                public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
                    BitmapDrawable drawableBitmap = new BitmapDrawable(bitmap);

                    actionBar.setLogo(drawableBitmap);

                }

                @Override
                public void onBitmapFailed(Drawable errorDrawable) {

                }

                @Override
                public void onPrepareLoad(Drawable placeHolderDrawable) {

                }
            });
        }
*/

      /*  if(channelID.equals("2")){
            actionBar.setLogo(R.drawable.sindhtv_logo);
        }else if(channelID.equals("3")){
            actionBar.setLogo(R.drawable.sindhtvnews_logo);
        }else{
            actionBar.setLogo(R.drawable.daily_jeejal_logo);
        }
*/
        mDrawerToggle = new ActionBarDrawerToggle(MainActivity.this,
                mDrawerLayout, R.string.drawer_open,
                R.string.drawer_close) {

            @Override
            public void onDrawerOpened(View drawerView) {
                // TODO Auto-generated method stub
                super.onDrawerOpened(drawerView);

                // Toast.makeText(getApplicationContext(), "open", 1000).show();

                mDrawerLayout.openDrawer(mDrawerList);

            }

            @Override
            public void onDrawerClosed(View drawerView) {
                // TODO Auto-generated method stub
                super.onDrawerClosed(drawerView);
                // Toast.makeText(getApplicationContext(), "close",
                // 1000).show();
                mDrawerLayout.closeDrawer(mDrawerList);
            }
        };
        mDrawerLayout.setDrawerListener(mDrawerToggle);

        // Enabling Home button

        actionBar.setDisplayHomeAsUpEnabled(true);
        actionBar.setHomeButtonEnabled(true);
        //actionBar.setDisplayShowHomeEnabled(true);

        // Setting item click listener for the listview mDrawerList

        mDrawerToggle.setDrawerIndicatorEnabled(true);
        mDrawerLayout.setDrawerListener(mDrawerToggle);

		/* Setting default fragment */
        selectedPosition = 0;

        // textTitle.setText("Home");


        new GetTabs().execute();

        //  textTitleHome.setText("Home");


        // int pagerPosition = shp.getInt("position_pager", 0);

        // mPager.setCurrentItem(0);
        // mPager.setOffscreenPageLimit(0);


    }

    @Override
    protected void onPause() {
        // TODO Auto-generated method stub
        LocalBroadcastManager.getInstance(this).unregisterReceiver(
                mRegistrationBroadcastReceiver);
        super.onPause();
    }

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();


        mDrawerList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {
                selectedPosition = position;

                if (arrMenuId.get(position).equals(8) || arrMenuId.get(position).equals(9)
                        || arrMenuId.get(position).equals(12) || arrMenuId.get(position).equals(13)
                        || arrMenuId.get(position).equals(15) || arrMenuId.get(position).equals(16)) {

                    if (arrMenuId.get(position).equals(8)) {

                        mDrawerLayout.closeDrawers();

                        Uri imageUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE +
                                "://" + getResources().getResourcePackageName(R.drawable.logo)
                                + '/' + getResources().getResourceTypeName(R.drawable.logo) + '/' + getResources().getResourceEntryName(R.drawable.logo));


                        int image = shp.getInt("channel_image", 0);
                       /* InputStream input = null;
                        //   Uri imageUri = Uri.parse(image);
                        try {
                            URL url = new URL(image);

                            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

                            connection.setDoInput(true);

                            connection.connect();

                             input = connection.getInputStream();


                        } catch (MalformedURLException e) {

                        } catch (IOException e) {

                        }

                        Bitmap immutableBpm = BitmapFactory.decodeStream(input);

                        Bitmap mutableBitmap = immutableBpm.copy(Bitmap.Config.ARGB_8888, true);


                        View viewImage = new View(MainActivity.this);

                        viewImage.draw(new Canvas(mutableBitmap));

                        String path = MediaStore.Images.Media.insertImage(getContentResolver(), mutableBitmap, "Nur", null);
*/

                      /*  Uri imageUriFinal = null;
                        try {
                            imageUri = Uri.parse(MediaStore.Images.Media.insertImage(MainActivity.this.getContentResolver(),
                                    BitmapFactory.decodeResource(getResources(), image), null, null));
                        } catch (NullPointerException e) {
                        }*/
                        // Uri uri = Uri.parse(path);

                        String text = "https://play.google.com/store/apps/details?id=com.it.admin.sindhtv";
                        //  Uri pictureUri = Uri.parse("file://my_picture");
                      /*  Intent shareIntent = new Intent();
                        shareIntent.setAction(Intent.ACTION_SEND);
                        shareIntent.putExtra(Intent.EXTRA_TEXT, text);
                        shareIntent.putExtra(Intent.EXTRA_STREAM, imageUriFinal);
                        shareIntent.setType("image*//*");
                        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                        startActivity(Intent.createChooser(shareIntent, "Share images..."));*/

                        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), image);
                        String path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + "/sindhttv.jpg";
                        OutputStream out = null;
                        File file = new File(path);
                        try {
                            out = new FileOutputStream(file);
                            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, out);
                            out.flush();
                            out.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        path = file.getPath();
                        Uri bmpUri = Uri.fromFile(new File(path));
                        Intent shareIntent = new Intent();
                        shareIntent = new Intent(android.content.Intent.ACTION_SEND);
                        shareIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        shareIntent.putExtra(Intent.EXTRA_TEXT, text);
                        shareIntent.putExtra(Intent.EXTRA_STREAM, bmpUri);
                        shareIntent.setType("image/*");
                        startActivity(Intent.createChooser(shareIntent, "Share with"));

                    } else if (arrMenuId.get(position).equals(12)) {


                        mDrawerLayout.closeDrawers();

                        startActivity(new Intent(MainActivity.this, com.it.admin.sindhtv.AboutActivity.class));

                    } else if (arrMenuId.get(position).equals(15)) {

                        mDrawerLayout.closeDrawers();

                        startActivity(new Intent(MainActivity.this, com.it.admin.sindhtv.ContactUsActivity.class));

                    } else if (arrMenuId.get(position).equals(16)) {

                        mDrawerLayout.closeDrawers();

                        startActivity(new Intent(MainActivity.this, com.it.admin.sindhtv.ProgramProfileActivity.class));

                    } else if (arrMenuId.get(position).equals(13)) {

                        mDrawerLayout.closeDrawers();

                        startActivity(new Intent(MainActivity.this, SettingAcivity.class));

                    } else {

                        mDrawerLayout.closeDrawers();

                        startActivity(new Intent(MainActivity.this, UserUploads.class));


                    }

                    //Toast.makeText(MainActivity.this,"Other Positions",1000).show();

                } else {

                    mPager.setCurrentItem(position);

                }

                mDrawerLayout.closeDrawers();

            }
        });


    }


    void init() {

        mPager = (ViewPager) findViewById(R.id.pager);
    }


    private class ViewPagerAdapter extends FragmentPagerAdapter {


        final int PAGE_COUNT = arrMenuNameTabs.size();
        // Tab Titles
        //  private String tabtitles[] = new String[]{"fragment1", "fragment2",
        //    "fragment3"};

        private IListFragment[] fragments = new IListFragment[PAGE_COUNT];

        public ViewPagerAdapter(FragmentManager fm) {
            super(fm);

            for (int i = 0; i < PAGE_COUNT; i++) {
                Bundle bundle = new Bundle();
                bundle.putInt("params", i + 1);
                fragments[i] = PagerFragment.newInstance(bundle);
            }

        }

        @Override
        public int getCount() {

            return PAGE_COUNT;
        }

        @Override
        public Fragment getItem(int position) {
            // switch (position) {

            int size = arrMenuId.size();
            int size1 = arrMenuCheckMenuType.size();

            for (int i = 0; i < arrMenuIdTabs.size(); i++) {

                String check = arrMenuCheckMenuType.get(position);
                Integer menuId = arrMenuIdTabs.get(position);

                //   if (check.equals("1")) {


                // } else {

                if (menuId.equals(1)) {

                    return new LiveFragment();

                } else if (menuId.equals(10)) {

                    return new VideosFragment();

                } else if (menuId.equals(7)) {

                    return new ArticleFragment();

                } else if (menuId.equals(3)) {

                    return new HeadlineFragments();

                } else if (menuId.equals(11)) {

                    return new EPaperFragent();

                    //    }


                }


            }
              /*  case 0:
                    return new LiveFragment();
                case 1:
                    return new LiveFragment();
                case 2:
                    return new LiveFragment();*/

               /* default:
                    break;*/
            //  }
            return null;
        }


        @Override
        public CharSequence getPageTitle(int position) {
            return arrMenuNameTabs.get(position);
        }


    }


    public static interface IListFragment {
        public ListView getListView();

        public View getPlaceHolderView();
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        mDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mDrawerToggle.onConfigurationChanged(newConfig);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

      /*  switch (item.getItemId()) {
            case R.id.menu_search:
                // Toast.makeText(getApplicationContext(),"FIRST",
                // Toast.LENGTH_SHORT).show();
                break;
            case R.id.menu_referesh:
                // Toast.makeText(getApplicationContext(),"FIRST+1",
                // Toast.LENGTH_SHORT).show();
                break;
        }*/
        return mDrawerToggle.onOptionsItemSelected(item);
    }

    class CustomAdapter extends BaseAdapter {

        @Override
        public int getCount() {
            // TODO Auto-generated method stub
            return arrMenuName.size();
        }

        @Override
        public Object getItem(int arg0) {
            // TODO Auto-generated method stub
            return arg0;
        }

        @Override
        public long getItemId(int arg0) {
            // TODO Auto-generated method stub
            return arg0;
        }

        @Override
        public View getView(int position, View arg1, ViewGroup arg2) {
            // TODO Auto-generated method stub

            LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);

            View view = null;

            view = inflater.inflate(R.layout.listview_row, null);

            ImageView image = (ImageView) view
                    .findViewById(R.id.imageViewIcon);
            TextView textName = (TextView) view
                    .findViewById(R.id.textViewName);

            textName.setTextColor(Color.parseColor(listTextColor));

            // image.setBackgroundResource(arrImages.get(position));
            Picasso.with(MainActivity.this).load(arrMenuImage.get(position)).into(image);

            textName.setText(arrMenuName.get(position));


            return view;
        }

    }

    private class GetTabs extends AsyncTask<Void, Void, Void> {

        private ProgressDialog progressDialog;

        @Override
        protected void onPreExecute() {
            super.onPreExecute();

            progressDialog = new ProgressDialog(MainActivity.this);
            progressDialog.setMessage("Loading...");
            progressDialog.setCancelable(false);
            progressDialog.show();

        }

        @Override
        protected Void doInBackground(Void... params) {

            String url = WebServicesUrls.BASE_URL + WebServicesUrls.GET_TABS + channelID;

            ServiceHandler service = new ServiceHandler();

            final String jsonStr = service.makeServiceCall(url,
                    ServiceHandler.GET);

            try {
                JSONObject jsonobject = new JSONObject(jsonStr);

                String epaper = jsonobject.getString("epaper_url");
                String about = jsonobject.getString("about_url");
                String contact_url = jsonobject.getString("contact_url");
//                String program_url = jsonobject.getString("program_url");

                String program_url;

                switch (channelID) {
                    case "2":
                        program_url = "http://sindhtvnews.net/app_pages/sindhtv_program.html";
                        break;
                    case "3":
                        program_url = "http://sindhtvnews.net/app_pages/news_program.html";
                        break;
                    default:
                        program_url = "http://sindhtvnews.net/app_pages/sindhtv_program.html";
                        break;
                }

                shp.edit().putString("epaper", epaper).putString("about_url", about).putString("contact_url", contact_url).putString("program_url", program_url).commit();

                JSONArray jsonArrayMian = jsonobject.getJSONArray("items");

                for (int j = 0; j < jsonArrayMian.length(); j++) {

                    JSONObject jsonobject2 = jsonArrayMian.getJSONObject(j);

                    Integer menu_id = jsonobject2.getInt("menu_id");
                    String menu_icon = jsonobject2.getString("menu_icon");
                    String menu_name = jsonobject2.getString("menu_name");
                    String is_listmenu = jsonobject2.getString("is_listmenu");

                    arrMenuId.add(menu_id);
                    arrMenuName.add(menu_name);
                    arrMenuImage.add(menu_icon);
                    arrMenuCheckMenuType.add(is_listmenu);

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

            if (progressDialog.isShowing()) {
                progressDialog.dismiss();
            }

            for (int i = 0; i < arrMenuId.size(); i++) {

                String check = arrMenuCheckMenuType.get(i);
                Integer menuId = arrMenuId.get(i);

                if (check.equals("1")) {

                } else {

                    arrMenuNameTabs.add(arrMenuName.get(i));
                    arrMenuIdTabs.add(arrMenuId.get(i));

                }
            }


            mDrawerList.setAdapter(new CustomAdapter());

            mPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());
            mTopView = (RelativeLayout) findViewById(R.id.topview);

            mTabStrip = (PagerSlidingTabStrip) findViewById(R.id.tabs);

            mTabStrip.setBackgroundColor(Color.parseColor(tabBgColor));
            mTabStrip.setIndicatorColor(Color.parseColor(tabUnderColor));
            mTabStrip.setDividerColor(Color.parseColor(tabSepColor));
            mTabStrip.setTextColor(Color.parseColor(tabTextColor));

            mPager.setAdapter(mPagerAdapter);
            // mPager.setOffscreenPageLimit(mPagerAdapter.getCount());
            mTabStrip.setViewPager(mPager);

            int pos = shp.getInt("position", 0);

            mPager.setCurrentItem(pos);
        }
    }

    @Override
    public void onOptionsMenuClosed(Menu menu) {
        finish();
        super.onOptionsMenuClosed(menu);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // TODO Auto-generated method stub

        getMenuInflater().inflate(com.it.admin.sindhtv.R.menu.menu_main, menu);

        MenuItem menuItemReferesh = menu.findItem(R.id.menu_referesh);
        menuItemReferesh
                .setOnMenuItemClickListener(new android.view.MenuItem.OnMenuItemClickListener() {

                    @Override
                    public boolean onMenuItemClick(MenuItem item) {
                        // TODO Auto-generated method stub

                        int pos = mPager.getCurrentItem();

                        shp.edit().putInt("position", pos).commit();

                        startActivity(new Intent(com.it.admin.sindhtv.MainActivity.this,
                                com.it.admin.sindhtv.MainActivity.class));
                        finish();

                        return true;
                    }
                });


        return true;
    }

    @Override
    public void onBackPressed() {

        //   shp.edit().clear().commit();
        Log.i("MainActivity", "nothing on backstack, calling super");
        super.onBackPressed();

    }

}