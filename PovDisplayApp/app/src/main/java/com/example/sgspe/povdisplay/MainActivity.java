package com.example.sgspe.povdisplay;

import android.Manifest;
import android.annotation.TargetApi;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import java.io.*;
import java.net.Socket;

public class MainActivity extends AppCompatActivity {
    Button button;
    Button sendImg;
    ImageView imageview;
    Uri imageURI;
    TextView textview;
    private static Socket socket;
    private static final int REQUEST_EXTERNAL_STORAGE = 1;
    private static String[] PERMISSIONS_STORAGE = {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        button = (Button)findViewById(R.id.button);
        sendImg = (Button)findViewById(R.id.button2);
        imageview = (ImageView)findViewById(R.id.imageView);
        textview = (TextView)findViewById(R.id.textView3);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openGalary();
            }
        });
        sendImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new SendImage().execute("192.168.0.37", "8000");
            }
        });
    }

    private void openGalary(){
        Intent getImage = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI);
        startActivityForResult(getImage , 100);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode,resultCode,data);
        if(resultCode == RESULT_OK && requestCode == 100){
            imageURI = data.getData();
            imageview.setImageURI(imageURI);


        }
    }

    public void showToast(final String toast)
    {
        runOnUiThread(new Runnable() {
            public void run()
            {
                Toast.makeText(MainActivity.this, toast, Toast.LENGTH_SHORT).show();

            }
        });
    }

    public void showText(final String text)
    {
        runOnUiThread(new Runnable() {
            public void run()
            {
                textview.setText(text);
            }
        });
    }

    @TargetApi(23)
    protected void askForPermission() {
        String[] permissions = {
                "android.permission.READ_EXTERNAL_STORAGE",
                "android.permission.WRITE_EXTERNAL_STORAGE"
        };
        int requestCode = 200;
        requestPermissions(permissions, requestCode);
    }

    private class SendImage extends AsyncTask<String,Void,String> {
        @Override
        protected String doInBackground(String... arg0) {
            try {
                socket = new Socket(arg0[0],Integer.parseInt(arg0[1]));
                File myFile = new File(getPathFromURI(imageURI));
                askForPermission();
                BufferedInputStream bis = new BufferedInputStream(new FileInputStream(myFile));
                byte [] bytearray  = new byte [(int)myFile.length()];
                bis.read(bytearray,0,bytearray.length);
                OutputStream os = socket.getOutputStream();
                os.write(bytearray,0,bytearray.length);
                os.flush();
                showText("Sent Image!");
                socket.close();
                return "successful!";
            } catch (IOException e) {
                e.printStackTrace();
                showText("Server Failure");
            }
            return null;
        }
        @Override
        protected void onPostExecute(String result){
            if (result != null) {
                showToast("Sent");
            } else {
                showToast("Sending Failed");
            }
        }
        private String getPathFromURI(Uri contentURI) {
            String result="";
            Cursor cursor = getContentResolver().query(contentURI, null, null, null, null);
            cursor.moveToFirst();
            int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            result = cursor.getString(idx);
            cursor.close();
            return result;
        }

    }
}