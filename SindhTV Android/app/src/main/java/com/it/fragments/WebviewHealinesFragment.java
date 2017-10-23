package com.it.fragments;

import android.app.FragmentManager;
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
public class WebviewHealinesFragment extends Fragment {


    private ProgressBar progress;
    private WebView webView;

    public static WebviewHealinesFragment newInstance(Bundle bundle) {
        WebviewHealinesFragment fragment = new WebviewHealinesFragment();
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

        View fakeHeader = inflater.inflate(R.layout.webview_article, null);
        SharedPreferences shp = getActivity().getSharedPreferences("sindhtv", 0);
        String url_webview = shp.getString("url_webview","");




        webView = (WebView)fakeHeader. findViewById(R.id.webView);
        progress = (ProgressBar)fakeHeader.findViewById(R.id.progressScroll);

        webView.getSettings().setAllowFileAccess(true);

        webView.getSettings().setJavaScriptEnabled(true);

        webView.setWebViewClient(new MyWebViewClient());

        webView.loadUrl(url_webview);

        onBack();


        return fakeHeader;
    }

    public  void onBack()
    {

        FragmentManager g = getActivity().getFragmentManager();

        g.popBackStack();
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

}

