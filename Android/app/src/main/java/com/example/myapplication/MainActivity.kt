package com.example.myapplication

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_main.*


class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val permissions = arrayOf(
            android.Manifest.permission.READ_EXTERNAL_STORAGE,
            android.Manifest.permission.WRITE_EXTERNAL_STORAGE
        )
        requestPermissions(permissions, 200)

        nextBtn.setOnClickListener {
            val intent = Intent(this@MainActivity, SecondActivity::class.java).apply {
                putExtra("bedroom", bedroom.text.toString().toInt())
                putExtra("bathroom", bathroom.text.toString().toDouble())
                putExtra("sqftlot", sqft_lot.text.toString().toDouble())
                putExtra("floors", floor.text.toString().toInt())
                putExtra("sqftabove", sqft_above.text.toString().toDouble())
                putExtra("sqftbasement", sqft_basement.text.toString().toDouble())
            }
            startActivity(intent)
        }
    }

}
