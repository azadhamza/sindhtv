package com.it.admin.sindhtv;

/**
 * Created by Vipan on 5/13/2016.
 */
public class AboutActivity  extends android.support.v7.app.AppCompatActivity{
    private android.widget.ProgressBar progress;
    private android.webkit.WebView webView;



    @Override
    protected void onCreate(android.os.Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.about);



        android.content.SharedPreferences shp = getSharedPreferences("sindhtv", 0);
        String url_webview = shp.getString("about_url","");
       String  actionbarColor = shp.getString("actionbar_color", "");

/*        String banner_code_ios = shp.getString("banner_code_ios", "");

        android.widget.LinearLayout adContainer = (android.widget.LinearLayout)findViewById(com.it.admin.sindhtv.R.id.linearAdAbout);
        com.google.android.gms.ads.AdView adView = new com.google.android.gms.ads.AdView(com.it.admin.sindhtv.AboutActivity.this);
        adView.setAdSize(com.google.android.gms.ads.AdSize.SMART_BANNER);
        adView.setAdUnitId(banner_code_ios);

// Initiate a generic request to load it with an ad
        com.google.android.gms.ads.AdRequest adRequest = new com.google.android.gms.ads.AdRequest.Builder().build();

        adView.loadAd(adRequest);

        android.widget.LinearLayout.LayoutParams params = new android.widget.LinearLayout.LayoutParams(android.widget.LinearLayout.LayoutParams.MATCH_PARENT, android.widget.LinearLayout.LayoutParams.MATCH_PARENT);
        adContainer.addView(adView, params);*/


        getSupportActionBar().setTitle("About");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        getSupportActionBar().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.parseColor(actionbarColor)));


        webView = (android.webkit.WebView) findViewById(R.id.webViewAbout);
        progress = (android.widget.ProgressBar)findViewById(R.id.progressScrollAbout);

        webView.getSettings().setAllowFileAccess(true);
        webView.getSettings().setBuiltInZoomControls(true);


        webView.getSettings().setJavaScriptEnabled(true);

        webView.setWebViewClient(new MyWebViewClient());

        webView.loadUrl(url_webview);
    }




    private class MyWebViewClient extends android.webkit.WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(android.webkit.WebView view, String url) {
            view.loadUrl(url);

            return true;
        }

        @Override
        public void onPageStarted(android.webkit.WebView view, String url, android.graphics.Bitmap favicon) {
            // TODO Auto-generated method stub
            super.onPageStarted(view, url, favicon);

            progress.setVisibility(android.view.View.VISIBLE);

        }

        @Override
        public void onPageFinished(android.webkit.WebView view, String url) {
            // TODO Auto-generated method stub
            super.onPageFinished(view, url);

            progress.setVisibility(android.view.View.GONE);



        }
    }

    @Override
    public void onPause() {
        // TODO Auto-generated method stub
        super.onPause();

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.HONEYCOMB) {
            if (webView == null) {

            } else {
                webView.onPause();
            }

        }

    }

    @Override
    public boolean onOptionsItemSelected(android.view.MenuItem item) {
        finish();
        return super.onOptionsItemSelected(item);
    }
}


