package com.example.calm_notes

// Import FlutterActivity
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity

class SplashScreenActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        // Start FlutterActivity
        startActivity(
            FlutterActivity.createDefaultIntent(this@SplashScreenActivity)
        )


        // Finish the splash screen activity
        finish()
    }
}