package com.it.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.TextView;

import com.it.admin.sindhtv.R;
import com.squareup.picasso.Picasso;

import java.util.HashMap;
import java.util.List;

public class MainCategoriesAdapter extends BaseExpandableListAdapter {

	private Context _context;
	private List<String> _listDataHeader; // header
											// titles
	// child data in format of header title, child title
	private HashMap<String, List<String>> _listDataTitle, _listDataImage,
			_listDataDurations, _listDatausername, _listDataViewsTime,
			_listDataID;

	// private HashMap<String, List<String>> _listDataChildminntiming;
	// private HashMap<String, List<String>> _listDataChildrating;

	public MainCategoriesAdapter(Context context, List<String> listDataHeader,
			HashMap<String, List<String>> listChildTitle,
			HashMap<String, List<String>> listDataImage,
			HashMap<String, List<String>> listDataDurations,
			HashMap<String, List<String>> listDatausername,
			HashMap<String, List<String>> listDataViewsTime,
			HashMap<String, List<String>> listDataID) {
		this._context = context;
		this._listDataHeader = listDataHeader;
		this._listDataTitle = listChildTitle;
		this._listDataImage = listDataImage;

		this._listDataDurations = listDataDurations;
		this._listDatausername = listDatausername;
		this._listDataViewsTime = listDataViewsTime;

		this._listDataID = listDataID;

	}

	@Override
	public Object getChild(int groupPosition, int childPosititon) {
		return this._listDataTitle.get(this._listDataHeader.get(groupPosition))
				.get(childPosititon);
	}

	private String getChildDescription(int groupPosition, int childPosition) {
		return this._listDataImage.get(this._listDataHeader.get(groupPosition))
				.get(childPosition);
	}

	private String getChildDuration(int groupPosition, int childPosition) {
		return this._listDataDurations.get(
				this._listDataHeader.get(groupPosition)).get(childPosition);
	}

	private String getChildUsername(int groupPosition, int childPosition) {
		return this._listDatausername.get(
				this._listDataHeader.get(groupPosition)).get(childPosition);
	}

	private String getChildViewsTime(int groupPosition, int childPosition) {
		return this._listDataViewsTime.get(
				this._listDataHeader.get(groupPosition)).get(childPosition);
	}
	
	public  String getChildID(int groupPosition, int childPosition) {
		return this._listDataID.get(
				this._listDataHeader.get(groupPosition)).get(childPosition);
	}


	/*
	 * private String getChildRating(int groupPosition, int childPosition) {
	 * return this._listDataChildrating.get(
	 * this._listDataHeader.get(groupPosition)).get(childPosition); }
	 */

	@Override
	public long getChildId(int groupPosition, int childPosition) {
		return childPosition;
	}

	@Override
	public View getChildView(int groupPosition, final int childPosition,
			boolean isLastChild, View convertView, ViewGroup parent) {

		final String childText = (String) getChild(groupPosition, childPosition);
		final String childImage = (String) getChildDescription(groupPosition,
				childPosition);
		final String childDuration = (String) getChildDuration(groupPosition,
				childPosition);

		final String childUsername = (String) getChildUsername(groupPosition,
				childPosition);

		final String childViewsTime = (String) getChildViewsTime(groupPosition,
				childPosition);
		/*
		 * final String MinnTiming = (String) getChildMinnTiming(groupPosition,
		 * childPosition); final String Rating = (String)
		 * getChildRating(groupPosition, childPosition);
		 */

		if (convertView == null) {
			LayoutInflater infalInflater = (LayoutInflater) this._context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = infalInflater.inflate(R.layout.custom_home, null);
		}

		ImageView imageVideoAccount = (ImageView) convertView
				.findViewById(R.id.imageVideoAccount1);

		TextView textVideo = (TextView) convertView
				.findViewById(R.id.textVideoAccounnt1);

		TextView textTime = (TextView) convertView.findViewById(R.id.textTime1);
		TextView textVideoLives = (TextView) convertView
				.findViewById(R.id.textVideoLives1);
		TextView textVideoBy = (TextView) convertView
				.findViewById(R.id.textVideoBy);

		textVideo.setText(childText);
		Picasso.with(_context).load(childImage).placeholder(R.drawable.black).into(imageVideoAccount);

		textTime.setText(childDuration);
		textVideoBy.setText(childUsername);
		textVideoLives.setText(childViewsTime);

		/*
		 * txtMinnTiming.setText(MinnTiming); txtrating.setText(Rating);
		 */
		return convertView;
	}

	@Override
	public int getChildrenCount(int groupPosition) {
		return this._listDataTitle.get(this._listDataHeader.get(groupPosition))
				.size();
	}

	@Override
	public Object getGroup(int groupPosition) {
		return this._listDataHeader.get(groupPosition);
	}

	@Override
	public int getGroupCount() {
		return this._listDataHeader.size();
	}

	@Override
	public long getGroupId(int groupPosition) {
		return groupPosition;
	}

	@Override
	public View getGroupView(int groupPosition, boolean isExpanded,
			View convertView, ViewGroup parent) {
		String headerTitle = (String) getGroup(groupPosition);

		if (convertView == null) {
			LayoutInflater infalInflater = (LayoutInflater) this._context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			convertView = infalInflater.inflate(R.layout.group_item, null);
		}

		ExpandableListView mExpandableListView = (ExpandableListView) parent;
		mExpandableListView.expandGroup(groupPosition);
		mExpandableListView.setHorizontalScrollBarEnabled(true);

		TextView lblListHeaderName = (TextView) convertView
				.findViewById(R.id.text1);
		lblListHeaderName.setText(headerTitle);

		return convertView;
	}

	@Override
	public boolean hasStableIds() {
		return false;
	}

	@Override
	public boolean isChildSelectable(int groupPosition, int childPosition) {
		return true;
	}

}
