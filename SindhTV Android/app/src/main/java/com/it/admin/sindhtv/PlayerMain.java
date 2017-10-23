package com.it.admin.sindhtv;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebSettings.PluginState;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.ArrayList;

public class PlayerMain extends Activity {
	// private WebView myWebView;
	protected FrameLayout webViewPlaceholder;
	protected WebView webView;
	private ProgressBar progress, progressScroll;
	private Button btnFullScreen, btSmallScreen;
	private RelativeLayout scroll;
	private ListView listComments;
	SharedPreferences shp;
	String VIDEO_URL, id , key = "";

	private String name = "", username = "", image = "", views = "", time = "",
			descr = "", storeComment = "", source = "", urlVideo = "";

	ProgressBar pb;
	Dialog dialog;
	int downloadedSize = 0;
	int totalSize = 0;
	TextView cur_val;
	boolean isTextViewClicked = false;
	private boolean RESULT_FLAG = false;

	private ArrayList<String> arrVid = new ArrayList<String>();
	private ArrayList<String> arrTitle = new ArrayList<String>();
	private ArrayList<String> arrImage = new ArrayList<String>();
	boolean flag = false;
	private Activity mainActivity;
	private com.google.android.gms.ads.InterstitialAd interstitial;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.main);

		mainActivity = (Activity) this;


		shp = getSharedPreferences("sindhtv", 0);

		String idData = shp.getString("url", "");

		String interstitial_code_ios = shp.getString("interstitial_code_ios","");

		com.google.android.gms.ads.AdRequest adRequest1 = new com.google.android.gms.ads.AdRequest.Builder()
				.build();
		interstitial = new com.google.android.gms.ads.InterstitialAd(this);
		interstitial.setAdUnitId(interstitial_code_ios);
		interstitial.loadAd(adRequest1);

		interstitial.setAdListener(new com.google.android.gms.ads.AdListener() {
			@Override
			public void onAdLoaded() {
				// Toast.makeText(getApplicationContext(), "Load", 1000).show();
				interstitial.show();

			}

			@Override
			public void onAdFailedToLoad(int errorCode) {

				// Toast.makeText(getApplicationContext(), "Not Load",
				// 1000).show();
				// Change the button text and disable the button.

			}
		});

		VIDEO_URL = idData;

		Settings.System.putInt(getContentResolver(),
				Settings.System.ACCELEROMETER_ROTATION, 1// 0 means off, 1 means
															// on
				);


		initUI();

	}

	@Override
	protected void onStart() {
		// TODO Auto-generated method stub
		super.onStart();

	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();

		webView.onResume();

	}

	@SuppressWarnings("deprecation")
	@SuppressLint({ "NewApi", "JavascriptInterface", "SetJavaScriptEnabled" })
	protected void initUI() {
		// Retrieve UI elements

		progress = (ProgressBar) findViewById(R.id.progress);

		if (webView == null) {
			// Create the webview
			webView = (WebView) findViewById(R.id.webView);

			webView.setBackgroundColor(Color.BLACK);

			webView.setWebViewClient(new MyWebViewClient());

			webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
			webView.getSettings().setAppCacheEnabled(false);
			webView.clearCache(true);
			webView.getSettings().setPluginState(PluginState.ON);
			webView.getSettings().setJavaScriptEnabled(true);

			webView.addJavascriptInterface(new WebAppInterface(this), "Poovee");

			int SDK_INT = Build.VERSION.SDK_INT;
			if (SDK_INT > 16) {
				webView.getSettings()
						.setMediaPlaybackRequiresUserGesture(false);
			}

			webView.loadUrl(VIDEO_URL);

		}

	}

	public class WebAppInterface {
		Context mContext;

		/** Instantiate the interface and set the context */
		WebAppInterface(Context c) {
			mContext = c;
		}

		@JavascriptInterface
		public void share(String url) {

			startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));

		}

	}

	private class MyWebViewClient extends WebViewClient {

		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {

			String urlCheck = url;

			view.loadUrl(url);
			return true;
		}

		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			// TODO Auto-generated method stub
			super.onPageStarted(view, url, favicon);
			progress.setVisibility(View.VISIBLE);

		}

		@Override
		public void onPageFinished(WebView view, String url) {
			// TODO Auto-generated method stub
			super.onPageFinished(view, url);
			progress.setVisibility(View.GONE);

		}

	}

	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub

		if (webView != null) {
			webView.stopLoading();
			webView.loadUrl("");
			webView.reload();
			webView.removeAllViews();
			webView = null;

		}
		finish();
	}

	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			if (webView == null) {

			} else {
				webView.onPause();
			}

		}

	}



}