package com.it.fragments;

import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

import com.it.admin.sindhtv.R;

/**
 * Created by admin on 4/26/2016.
 */
public class EPaperFragent extends Fragment {


    private ProgressBar progress;
    private WebView webView;
    private String url_webview;
    private boolean isFirstTime = true;

    public static EPaperFragent newInstance(Bundle bundle) {
        EPaperFragent fragment = new EPaperFragent();
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
        View fakeHeader = inflater.inflate(R.layout.webview_article, null);
        SharedPreferences shp = getActivity().getSharedPreferences("sindhtv", 0);
         url_webview = shp.getString("epaper","");

        webView = (WebView)fakeHeader. findViewById(R.id.webView);
        progress = (ProgressBar)fakeHeader.findViewById(R.id.progressScroll);

        webView.getSettings().setAllowFileAccess(true);

        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.getSettings().setUseWideViewPort(true);
        webView.getSettings().setBuiltInZoomControls(true);


        webView.setWebViewClient(new MyWebViewClient());

        webView.loadUrl(url_webview);



        webView.setOnKeyListener(new android.view.View.OnKeyListener()
        {
            @Override
            public boolean onKey(View v, int keyCode, android.view.KeyEvent event)
            {
                if(event.getAction() == android.view.KeyEvent.ACTION_DOWN)
                {
                    WebView webView = (WebView) v;

                    switch(keyCode)
                    {
                        case android.view.KeyEvent.KEYCODE_BACK:
                            if(webView.canGoBack())
                            {
                                webView.goBack();
                                return true;
                            }
                            break;
                    }
                }

                return false;
            }
        });
        return fakeHeader;
    }


    private class MyWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
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
    public void onPause() {
        // TODO Auto-generated method stub
        super.onPause();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            if (webView == null) {

            } else {
                webView.onPause();
            }

        }

    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            if (!isFirstTime) {
                webView.loadUrl(url_webview);
            }
        } else {

        }
    }




}