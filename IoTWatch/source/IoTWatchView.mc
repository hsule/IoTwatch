using Toybox.WatchUi;
using Toybox.Communications as Comm;
using Toybox.Sensor;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Sensor;
using Toybox.Application;
using Toybox.Position;
using Toybox.Timer;

class IoTWatchView extends WatchUi.View {
    var dataTimer = new Timer.Timer();
    var receive = 0;

    //Fill in this variable with the time interval in ms that you want to use for submitting data. Lower values will cause more calls so will cost more!
    var timer = 10000;
    
    function initialize() {
        View.initialize();
        register();
        sensor1();

    }

    function register() {
        var params = {
            "profile" =>
            {
                "d_name" => "watch_dashboard",
                "dm_name" => "watch_dashboard",
                "u_name" => "yb",
                "is_sim" => false,
                "df_list" => ["w_alt_i", "w_cad_i", "w_hR_i", "w_heading_i", "w_lat_i", 
                            "w_long_i", "w_power_i", "w_pressure_i", "w_speed_i", "w_temp_i", 
                            "w_xAcc_i", "w_xMag_i", "w_yAcc_i", "w_yMag_i", "w_zMag_i"]
            }
        };
        var headers = {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
        };
        var options = {
            :headers => headers,
            :method => Communications.HTTP_REQUEST_METHOD_POST,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard", params, options, method(:onReceive));
        // Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard", params, options, method(:onReceive));
    }

    var headers = {
        "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
    };
    var options = {
        :headers => headers,
        :method => Communications.HTTP_REQUEST_METHOD_PUT,
        :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
    };

    //Accelerometer
    function sensor1() {
        var sensorInfo = Sensor.getInfo();
        var xAccel = 0;
        if (sensorInfo has :accel && sensorInfo.accel != null) {
            xAccel = sensorInfo.accel[0];
        }
        else {
            xAccel = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_xAcc_i", {"data" => [xAccel.toNumber()]}, options, method(:onReceive1));

        var yAccel = 0;
        if (sensorInfo has :accel && sensorInfo.accel != null) {
            yAccel = sensorInfo.accel[1];
        }
        else {
            yAccel = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_yAcc_i", {"data" => [yAccel.toNumber()]}, options, method(:onReceive1));

        var hR = 0;
        if (sensorInfo has :heartRate && sensorInfo.heartRate != null) {
            hR = sensorInfo.heartRate;
        }
        else {
            hR = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_hR_i", {"data" => [hR.toNumber()]}, options, method(:onReceive1));
    }

    //heading
    function sensor2() {
        var sensorInfo = Sensor.getInfo();
        var heading;
        if (sensorInfo has :heading && sensorInfo.heading != null) {
            heading = sensorInfo.heading;
        }
        else {
            heading = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_heading_i", {"data" => [heading.toFloat()]}, options, method(:onReceive2));

        var xMag;
        if (sensorInfo has :mag && sensorInfo.mag != null) {
            xMag = sensorInfo.mag[0];
        }
        else {
            xMag = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_xMag_i", {"data" => [xMag.toNumber()]}, options, method(:onReceive2));

        var yMag;
        if (sensorInfo has :mag && sensorInfo.mag != null) {
            yMag = sensorInfo.mag[1];
        }
        else {
            yMag = 1;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_yMag_i", {"data" => [yMag.toNumber()]}, options, method(:onReceive2));

        var zMag;
        if (sensorInfo has :mag && sensorInfo.mag != null) {
            zMag = sensorInfo.mag[2];
        }
        else {
            zMag = 2;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_zMag_i", {"data" => [zMag.toNumber()]}, options, method(:onReceive2));
    }

    function onReceive(responseCode, data) {
        // System.println("1 requestCallback " + responseCode + ", data = " + data);
    }

    function onReceive1(responseCode, data) {
        // System.println("1 requestCallback " + responseCode + ", data = " + data);
        receive = receive + 1;
        // System.println(receive);
        if(receive == 3) {
            receive = 0;
            sensor2();
        }
    }

    function onReceive2(responseCode, data) {
        // System.println("2 requestCallback " + responseCode + ", data = " + data);
        receive = receive + 1;
        // System.println(receive);
        if(receive == 4) {
            receive = 0;
            sensor1();
        }
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
      View.onUpdate(dc);
    }

    function onHide() {
    }

}
