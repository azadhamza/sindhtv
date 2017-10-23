package com.it.utility;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.it.admin.sindhtv.MainActivity;

import java.util.ArrayList;
import java.util.List;


public class PagerFragment extends Fragment implements MainActivity.IListFragment {
	
	
	public static interface OnScrollChanged{
		public void onScrollChange(ListView listView, View placeHolder);
	}

	private static final String TAG = "PagerFragment";
	
	private int params;
	private ListView listView;
	private View placeHolder;
	public static PagerFragment newInstance(Bundle bundle){
		PagerFragment fragment=new PagerFragment();
		fragment.setArguments(bundle);
		return fragment;
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if (getArguments()!=null) {
			params=getArguments().getInt("params");
		}
	}
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		listView=new ListView(getActivity());
		//View fakeHeader=inflater.inflate(R.layout.fake_listview_header, null);
		//listView.addHeaderView(fakeHeader);
		//placeHolder=fakeHeader.findViewById(R.id.fake_pager_tab_bar);
		return listView;
	}
	
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		Log.e(TAG, "onActivityCreated!!!!!!!!!!!!!");
		List<String> dataList=new ArrayList<String>();
		for(int i=0;i<50;i++){
			dataList.add("fragment "+params+ "Item  "+i);
		}
		
		ArrayAdapter<String> adapter=new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1, dataList);
		listView.setAdapter(adapter);
		listView.setOnScrollListener(new OnScrollListener() {

			@Override
			public void onScrollStateChanged(AbsListView view, int scrollState) {
				// TODO Auto-generated method stub

			}

			@Override
			public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount,
								 int totalItemCount) {
				if (getActivity() instanceof OnScrollChanged) {
					((OnScrollChanged) getActivity()).onScrollChange(listView, placeHolder);
				}

			}
		});
	}

	@Override
	public ListView getListView() {
		return listView;
	}

	@Override
	public View getPlaceHolderView() {
		return placeHolder;
	}
}