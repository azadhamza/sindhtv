package com.it.admin.sindhtv;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.widget.CompoundButton;
import android.widget.Switch;

/**
 * Created by Vipan on 5/13/2016.
 */
public class SettingAcivity extends AppCompatActivity {

    private Switch switchNotification;
    private  SharedPreferences shp;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.settings);

        switchNotification = (Switch)findViewById(R.id.switchNotification);

         shp = getSharedPreferences("sindhtv", 0);

        String  actionbarColor = shp.getString("actionbar_color", "");


        boolean checkSwitch = shp.getBoolean("switch",true);

        getSupportActionBar().setTitle("Settings");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        getSupportActionBar().setBackgroundDrawable(new android.graphics.drawable.ColorDrawable(android.graphics.Color.parseColor(actionbarColor)));



        // if(checkSwitch == false){
            switchNotification.setChecked(checkSwitch);
        //}else{
         //   switchNotification.setChecked(true);
       // }


        switchNotification.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {

                if (isChecked) {

                    switchNotification.setChecked(true);
                    shp.edit().putBoolean("switch", true).commit();

                } else {
                    switchNotification.setChecked(false);
                    shp.edit().putBoolean("switch", false).commit();
                }

            }
        });

    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        finish();
        return super.onOptionsItemSelected(item);
    }
}
