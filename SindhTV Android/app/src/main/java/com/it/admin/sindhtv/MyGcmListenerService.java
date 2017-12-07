/**
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.it.admin.sindhtv;

import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

public class MyGcmListenerService extends com.google.android.gms.gcm.GcmListenerService {

	private static final String TAG = "MyGcmListenerService";
	public static final int notifyID = 9001;

	@Override
	public void onMessageReceived(String from, android.os.Bundle data) {
		String message = data.getString("message");
		String title = data.getString("title");
		android.util.Log.d(TAG, "From: " + from);
		android.util.Log.d(TAG, "Message: " + message);

		SharedPreferences shp = getSharedPreferences("sindhtv", 0);

		boolean checkSwitch = shp.getBoolean("switch",true);

		if(checkSwitch == false){

		}else {
			sendNotificationNew(message, title);
		}
		// Intent notificationIntent = new Intent(this, MainActivity.class);
		// generateNotification(this, title, message, notificationIntent);

	}

	private void sendNotification(String message, String title) {
		android.content.Intent intent = new android.content.Intent(this, MainActivity.class);
		intent.addFlags(android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP);
		android.app.PendingIntent pendingIntent = android.app.PendingIntent.getActivity(this, 0,
				intent, android.app.PendingIntent.FLAG_ONE_SHOT);

		android.net.Uri defaultSoundUri = android.media.RingtoneManager
				.getDefaultUri(android.media.RingtoneManager.TYPE_NOTIFICATION);
		android.support.v4.app.NotificationCompat.Builder notificationBuilder = new android.support.v4.app.NotificationCompat.Builder(
				this).setSmallIcon(R.drawable.logo).setContentTitle(title)
				.setContentText(message).setAutoCancel(true)
				.setSound(defaultSoundUri).setContentIntent(pendingIntent);

		android.app.NotificationManager notificationManager = (android.app.NotificationManager) getSystemService(android.content.Context.NOTIFICATION_SERVICE);

		notificationManager.notify(0 // ID of notification ,
				, notificationBuilder.build());
	}

	/*
	 * private static void generateNotification(Context context, String title,
	 * String message, Intent notificationIntent) { int icon =
	 * R.drawable.logo_noti; long when = System.currentTimeMillis();
	 * NotificationManager notificationManager = (NotificationManager) context
	 * .getSystemService(Context.NOTIFICATION_SERVICE); Notification
	 * notification = new Notification(icon, message, when);
	 *
	 * // String title = context.getString(R.string.app_name);
	 *
	 * // set intent so it does not start a new activity
	 * notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP |
	 * Intent.FLAG_ACTIVITY_SINGLE_TOP); PendingIntent intent =
	 * PendingIntent.getActivity(context, 0, notificationIntent,
	 * PendingIntent.FLAG_UPDATE_CURRENT);
	 * notification.setLatestEventInfo(context, title, message, intent);
	 * notification.flags |= Notification.FLAG_AUTO_CANCEL;
	 * notificationManager.notify(0, notification); }
	 */

	private void sendNotificationNew(String message, String title) {

		//Bitmap bm = ((BitmapDrawable) getResources().getDrawable(
				//R.drawable.logo)).getBitmap();

		android.content.Intent resultIntent = new android.content.Intent(this, AllChannels.class);
		resultIntent.setFlags(android.content.Intent.FLAG_ACTIVITY_SINGLE_TOP);
		android.app.PendingIntent resultPendingIntent = android.app.PendingIntent.getActivity(this, 0,
				resultIntent, android.app.PendingIntent.FLAG_ONE_SHOT);

		android.app.NotificationManager mNotificationManager = (android.app.NotificationManager) getSystemService(android.content.Context.NOTIFICATION_SERVICE);

		Bitmap largeIcon = BitmapFactory.decodeResource(getResources(), R.drawable.app_icon);

		android.support.v4.app.NotificationCompat.Builder mNotifyBuilder = new android.support.v4.app.NotificationCompat.Builder(this)
				.setContentTitle(title)
				.setSmallIcon(R.drawable.notificationchecknew).setLargeIcon(largeIcon);

		mNotifyBuilder.setContentIntent(resultPendingIntent);

		int defaults = 0;
		defaults = defaults | android.app.Notification.DEFAULT_LIGHTS; //
		defaults = defaults | android.app.Notification.DEFAULT_VIBRATE;
		defaults = defaults | android.app.Notification.DEFAULT_SOUND;

		mNotifyBuilder.setDefaults(defaults);
		mNotifyBuilder.setContentText(message);
		mNotifyBuilder.setAutoCancel(true);
		mNotificationManager.notify(notifyID, mNotifyBuilder.build());
	}

	public android.graphics.Bitmap drawableToBitmap(android.graphics.drawable.Drawable drawable) {
		android.graphics.Bitmap bitmap = null;

		if (drawable instanceof android.graphics.drawable.BitmapDrawable) {
			android.graphics.drawable.BitmapDrawable bitmapDrawable = (android.graphics.drawable.BitmapDrawable) drawable;
			if (bitmapDrawable.getBitmap() != null) {
				return bitmapDrawable.getBitmap();
			}
		}

		if (drawable.getIntrinsicWidth() <= 0
				|| drawable.getIntrinsicHeight() <= 0) {
			bitmap = android.graphics.Bitmap.createBitmap(1, 1, android.graphics.Bitmap.Config.ARGB_8888);
		} else {
			bitmap = android.graphics.Bitmap.createBitmap(drawable.getIntrinsicWidth(),
					drawable.getIntrinsicHeight(), android.graphics.Bitmap.Config.ARGB_8888);
		}

		android.graphics.Canvas canvas = new android.graphics.Canvas(bitmap);
		drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
		drawable.draw(canvas);
		return bitmap;
	}

}
