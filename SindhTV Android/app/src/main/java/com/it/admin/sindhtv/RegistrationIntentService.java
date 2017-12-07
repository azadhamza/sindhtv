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

import java.io.IOException;

import com.it.utility.ServiceHandler;

public class RegistrationIntentService extends android.app.IntentService {

	private static final String TAG = "RegIntentService";
	private static final String[] TOPICS = { "global" };

	public RegistrationIntentService() {
		super(TAG);
	}

	@android.annotation.SuppressLint("NewApi")
	@Override
	protected void onHandleIntent(android.content.Intent intent) {
		android.content.SharedPreferences sharedPreferences = android.preference.PreferenceManager
				.getDefaultSharedPreferences(this);

		try {
			// In the (unlikely) event that multiple refresh operations occur
			// simultaneously,
			// ensure that they are processed sequentially.
			synchronized (TAG) {
				// [START register_for_gcm]
				// Initially this call goes out to the network to retrieve the
				// token, subsequent calls
				// are local.
				// [START get_token]
				com.google.android.gms.iid.InstanceID instanceID = com.google.android.gms.iid.InstanceID.getInstance(this);
				String token = instanceID.getToken("283133458170",
						com.google.android.gms.gcm.GoogleCloudMessaging.INSTANCE_ID_SCOPE, null);

				com.it.utility.GlobalArraylist.GCM_ID = token;

				new PostGCM().execute();
				// [END get_token]
				android.util.Log.i(TAG, "GCM Registration Token: " + token);

				// TODO: Implement this method to send any registration to your
				// app's servers.
				sendRegistrationToServer(token);

				// Subscribe to topic channels
				subscribeTopics(token);

				// You should store a boolean that indicates whether the
				// generated token has been
				// sent to your server. If the boolean is false, send the token
				// to your server,
				// otherwise your server should have already received the token.
				sharedPreferences
						.edit()
						.putBoolean(QuickstartPreferences.SENT_TOKEN_TO_SERVER,
								true).apply();
				// [END register_for_gcm]
			}
		} catch (Exception e) {
			android.util.Log.d(TAG, "Failed to complete token refresh", e);
			// If an exception happens while fetching the new token or updating
			// our registration data
			// on a third-party server, this ensures that we'll attempt the
			// update at a later time.
			sharedPreferences
					.edit()
					.putBoolean(QuickstartPreferences.SENT_TOKEN_TO_SERVER,
							false).apply();
		}
		// Notify UI that registration has completed, so the progress indicator
		// can be hidden.
		android.content.Intent registrationComplete = new android.content.Intent(
				QuickstartPreferences.REGISTRATION_COMPLETE);
		android.support.v4.content.LocalBroadcastManager.getInstance(this).sendBroadcast(
				registrationComplete);
	}

	/**
	 * Persist registration to third-party servers.
	 *
	 * Modify this method to associate the user's GCM registration token with
	 * any server-side account maintained by your application.
	 *
	 * @param token
	 *            The new token.
	 */
	private void sendRegistrationToServer(String token) {
		// Add custom implementation, as needed.
	}

	/**
	 * Subscribe to any GCM topics of interest, as defined by the TOPICS
	 * constant.
	 *
	 * @param token
	 *            GCM token
	 * @throws IOException
	 *             if unable to reach the GCM PubSub service
	 */
	// [START subscribe_topics]
	private void subscribeTopics(String token) throws java.io.IOException {
		for (String topic : TOPICS) {
			com.google.android.gms.gcm.GcmPubSub pubSub = com.google.android.gms.gcm.GcmPubSub.getInstance(this);
			pubSub.subscribe(token, "/topics/" + topic, null);
		}
	}

	private class PostGCM extends android.os.AsyncTask<Void, Void, Void> {

		String type_id, msg, member_id;
		private String jsonStr;

		@Override
		protected void onPreExecute() {
			super.onPreExecute();

		}

		@Override
		protected Void doInBackground(Void... params) {

			String url = null;
			try {
				url = "http://poovee.net/webservices/appgcm/2?gcmid="
						+ java.net.URLEncoder.encode(
								com.it.utility.GlobalArraylist.GCM_ID, "UTF-8");
			} catch (java.io.UnsupportedEncodingException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

			ServiceHandler service = new ServiceHandler();

			jsonStr = service.makeServiceCall(url, ServiceHandler.GET);

			try {

				org.json.JSONObject jsonobject2 = new org.json.JSONObject(jsonStr);

				type_id = jsonobject2.getString("type");

			} catch (org.json.JSONException e) {
				android.util.Log.e("Error", e.getMessage());
				e.printStackTrace();
			}
			return null;
		}

		@Override
		protected void onPostExecute(Void result) {
			// TODO Auto-generated method stub
			super.onPostExecute(result);

		}

	}
	// [END subscribe_topics]

}
