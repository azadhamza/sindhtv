package com.it.utility;

import java.io.IOException;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.os.Bundle;
import android.os.Environment;
import android.os.SystemClock;
import android.app.Activity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Chronometer;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends android.app.Activity {

	private android.media.MediaRecorder myRecorder;
	private android.media.MediaPlayer myPlayer;
	private String outputFile = null;
	private android.widget.Button startBtn;
	private android.widget.Button stopBtn,done;
	//private android.widget.Button playBtn;
//	private android.widget.Button stopPlayBtn;
//	private TextView text;
	private android.widget.Chronometer chronometer1;

	@Override
	protected void onCreate(android.os.Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(com.it.admin.sindhtv.R.layout.record_audio);

		//text = (TextView) findViewById(R.id.text1);
		chronometer1 = (android.widget.Chronometer) findViewById(com.it.admin.sindhtv.R.id.chronometer1);
		// store it to sd card
		//getActionBar().hide();

		startBtn = (android.widget.Button) findViewById(com.it.admin.sindhtv.R.id.start);
		startBtn.setOnClickListener(new android.view.View.OnClickListener() {

			@Override
			public void onClick(android.view.View v) {
				// TODO Auto-generated method stub
				chronometer1.setBase(android.os.SystemClock.elapsedRealtime());
				chronometer1.start();
				
				start(v);
			}
		});

		stopBtn = (android.widget.Button) findViewById(com.it.admin.sindhtv.R.id.stop);
		stopBtn.setOnClickListener(new android.view.View.OnClickListener() {

			@Override
			public void onClick(android.view.View v) {
				// TODO Auto-generated method stub
				chronometer1.stop();
				stop(v);
			}
		});

		done = (Button)findViewById(com.it.admin.sindhtv.R.id.done);
		done.setOnClickListener(new android.view.View.OnClickListener() {
			@Override
			public void onClick(android.view.View v) {

				android.content.Intent intent = new android.content.Intent();
				intent.putExtra("path",outputFile);
				setResult(RESULT_OK, intent);
				finish();

			}
		});



	}

	public void start(android.view.View view) {
		
		outputFile = android.os.Environment.getExternalStorageDirectory()
				.getAbsolutePath() + "/record.3gpp";
		try {
		myRecorder = new android.media.MediaRecorder();
		myRecorder.setAudioSource(android.media.MediaRecorder.AudioSource.MIC);
		myRecorder.setOutputFormat(android.media.MediaRecorder.OutputFormat.THREE_GPP);
		myRecorder.setAudioEncoder(android.media.MediaRecorder.OutputFormat.AMR_NB);
		myRecorder.setOutputFile(outputFile);
		

			myRecorder.prepare();
			myRecorder.start();
		} catch (IllegalStateException e) {
			// start:it is called before prepare()
			// prepare: it is called after start() or before setOutputFormat()
			e.printStackTrace();
		} catch (java.io.IOException e) {
			// prepare() fails
			e.printStackTrace();
		}

		//text.setText("Recording Point: Recording");
		startBtn.setEnabled(false);
		stopBtn.setEnabled(true);

		android.widget.Toast.makeText(getApplicationContext(), "Start recording...",
				android.widget.Toast.LENGTH_SHORT).show();
	}

	public void stop(android.view.View view) {
		try {
			myRecorder.stop();
			myRecorder.release();
			myRecorder = null;

			stopBtn.setEnabled(false);
			//playBtn.setEnabled(true);
			startBtn.setEnabled(true);
			//text.setText("Recording Point: Stop recording");

			android.widget.Toast.makeText(getApplicationContext(), "Stop recording...",
					android.widget.Toast.LENGTH_SHORT).show();
		} catch (IllegalStateException e) {
			// it is called before start()
			e.printStackTrace();
		} catch (RuntimeException e) {
			// no valid audio/video data has been received
			e.printStackTrace();
		}
	}

	public void play(android.view.View view) {
		try {
			myPlayer = new android.media.MediaPlayer();
			myPlayer.setDataSource(outputFile);
			myPlayer.prepare();
			myPlayer.start();

			//playBtn.setEnabled(false);
			//stopPlayBtn.setEnabled(true);
		//	text.setText("Recording Point: Playing");

			android.widget.Toast.makeText(getApplicationContext(),
					"Start play the recording...", android.widget.Toast.LENGTH_SHORT).show();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void stopPlay(android.view.View view) {
		try {
			if (myPlayer != null) {
				myPlayer.stop();
				myPlayer.release();
				myPlayer = null;
			//	playBtn.setEnabled(true);
			//	stopPlayBtn.setEnabled(false);
				startBtn.setEnabled(true);
				//text.setText("Recording Point: Stop playing");

				android.widget.Toast.makeText(getApplicationContext(),
						"Stop playing the recording...", android.widget.Toast.LENGTH_SHORT)
						.show();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@Override
	public void onBackPressed() {
		// TODO Auto-generated method stub
		super.onBackPressed();

		android.content.Intent intent = new android.content.Intent();
		intent.putExtra("path",outputFile);
		setResult(RESULT_OK, intent);
		finish();
	}



}
