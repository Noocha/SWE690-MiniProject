package com.example.myapplication

import android.os.Bundle
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_main2.*
import java.math.RoundingMode
import java.text.DecimalFormat
import java.text.SimpleDateFormat
import java.util.*


class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main2)

        var bedroomsValue = 0
        var bathroomsValue = 0.0
        var floorsValue = 0
        var sqftaboveValue = 0.0
        var sqftbasementValue = 0.0
        var sqftlotValue = 0.0

        var yrbuiltValue = ""
        var renovatedValue = ""
        var waterfrontValue = 0
        var viewValue = 0
        var conditionValue = 0
        var gradeValue = 0

        //waterfront
        val waterfrontAdapter = ArrayAdapter<EnumTextItem<Waterfront>>(
            this@SecondActivity,
            R.layout.spinner_item,
            listOf(
                EnumTextItem(Waterfront.YES, "ติดริมน้ำ"),
                EnumTextItem(Waterfront.NO, "ไม่ติดริมน้ำ")
            )
        ).also { adapter ->
            adapter.setDropDownViewResource(R.layout.spinner_item)
            waterfront.adapter = adapter
        }

        waterfront.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onNothingSelected(parent: AdapterView<*>?) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                val item = waterfrontAdapter.getItem(position)

                when (item?.id) {
                    Waterfront.NO -> waterfrontValue = 0
                    Waterfront.YES -> waterfrontValue = 1
                }
            }
        }

        //view
        val viewAdapter = ArrayAdapter<EnumTextItem<ViewEnum>>(
            this@SecondActivity,
            R.layout.spinner_item,
            listOf(
                EnumTextItem(ViewEnum.POOR, "แย่"),
                EnumTextItem(ViewEnum.BELOW, "ปรับปรุง"),
                EnumTextItem(ViewEnum.AVERAGE, "ปานกลาง"),
                EnumTextItem(ViewEnum.ABOVE, "ดี"),
                EnumTextItem(ViewEnum.EXCELLENT, "ดีมาก")
            )
        ).also { adapter ->
            adapter.setDropDownViewResource(R.layout.spinner_item)
            view.adapter = adapter
        }

        view.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onNothingSelected(parent: AdapterView<*>?) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                val item = viewAdapter.getItem(position)

                when (item?.id) {
                    ViewEnum.POOR -> viewValue = 0
                    ViewEnum.BELOW -> viewValue = 1
                    ViewEnum.AVERAGE -> viewValue = 2
                    ViewEnum.ABOVE -> viewValue = 3
                    ViewEnum.EXCELLENT -> viewValue = 4
                }
            }
        }

        //condition
        val conditionAdapter = ArrayAdapter<EnumTextItem<ConditionEnum>>(
            this@SecondActivity,
            R.layout.spinner_item,
            listOf(
                EnumTextItem(ConditionEnum.POOR, "แย่"),
                EnumTextItem(ConditionEnum.BELOW, "ปรับปรุง"),
                EnumTextItem(ConditionEnum.AVERAGE, "ปานกลาง"),
                EnumTextItem(ConditionEnum.ABOVE, "ดี"),
                EnumTextItem(ConditionEnum.EXCELLENT, "ดีมาก")
            )
        ).also { adapter ->
            adapter.setDropDownViewResource(R.layout.spinner_item)
            condition.adapter = adapter
        }

        condition.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onNothingSelected(parent: AdapterView<*>?) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                val item = conditionAdapter.getItem(position)

                when (item?.id) {
                    ConditionEnum.POOR -> conditionValue = 1
                    ConditionEnum.BELOW -> conditionValue = 2
                    ConditionEnum.AVERAGE -> conditionValue = 3
                    ConditionEnum.ABOVE -> conditionValue = 4
                    ConditionEnum.EXCELLENT -> conditionValue = 5
                }
            }
        }

        //grade
        val gradeAdapter = ArrayAdapter(
            this@SecondActivity,
            R.layout.spinner_item,
            listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13)
        ).also { adapter ->
            adapter.setDropDownViewResource(R.layout.spinner_item)
            grade.adapter = adapter
        }

        val years = ArrayList<String>()
        val thisYear = Calendar.getInstance().get(Calendar.YEAR)
        for (i in 1900..thisYear) {
            years.add(i.toString())
        }
        val adapter = ArrayAdapter(this@SecondActivity, R.layout.spinner_item, years)
        yr_built.adapter = adapter

        //renovate
        val renovatedAdapter = ArrayAdapter<EnumTextItem<Waterfront>>(
            this@SecondActivity,
            R.layout.spinner_item,
            listOf(
                EnumTextItem(Waterfront.YES, "มีการปรับปรุง"),
                EnumTextItem(Waterfront.NO, "ไม่มีการปรับปรุง")
            )
        ).also { adapter ->
            adapter.setDropDownViewResource(R.layout.spinner_item)
            renovated.adapter = adapter
        }

        renovated.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onNothingSelected(parent: AdapterView<*>?) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onItemSelected(
                parent: AdapterView<*>?,
                view: View?,
                position: Int,
                id: Long
            ) {
                val item = renovatedAdapter.getItem(position)

                when (item?.id) {
                    Waterfront.NO -> renovatedValue = "N"
                    Waterfront.YES -> renovatedValue = "Y"
                }
            }
        }

        submitBtn.setOnClickListener {

            val snackbar = Snackbar.make(activity2, "Predicting...", Snackbar.LENGTH_INDEFINITE)
            snackbar.show()
            val thread = Thread {
                bedroomsValue = intent.getIntExtra("bedroom", 0)
                bathroomsValue = intent.getDoubleExtra("bathroom", 0.0)
                sqftlotValue = intent.getDoubleExtra("sqftlot", 0.0)
                floorsValue = intent.getIntExtra("floors", 0)
                sqftaboveValue = intent.getDoubleExtra("sqftabove", 0.0)
                sqftbasementValue = intent.getDoubleExtra("sqftbasement", 0.0)
                gradeValue = grade.selectedItem.toString().toInt()
                yrbuiltValue = yr_built.selectedItem.toString()

                val df2 = DecimalFormat("#,###.##")
                Test.trainAndTest()
                val resultDouble = Test.predictOneInstance(
                    SimpleDateFormat("yyyyMMdd").format(Date()),
                    bedroomsValue,
                    bathroomsValue,
                    sqftlotValue,
                    floorsValue,
                    waterfrontValue,
                    viewValue,
                    conditionValue,
                    gradeValue,
                    sqftaboveValue,
                    sqftbasementValue,
                    yrbuiltValue,
                    renovatedValue
                )
                df2.roundingMode = RoundingMode.CEILING
                runOnUiThread {
                    result.text = df2.format(resultDouble) + " USD"
                    snackbar.dismiss()
                }
            }
            thread.start()
        }

    }

    class EnumTextItem<T>(val id: T, val text: String) {
        override fun toString(): String {
            return text
        }
    }

    enum class Waterfront {
        YES, NO
    }

    enum class ViewEnum {
        POOR, BELOW, AVERAGE, ABOVE, EXCELLENT
    }

    enum class ConditionEnum {
        POOR, BELOW, AVERAGE, ABOVE, EXCELLENT
    }
}
