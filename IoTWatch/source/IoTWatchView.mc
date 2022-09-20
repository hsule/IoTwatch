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
    var receive = 3;

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
    }

    //Accelerometer
    function sensor2() {
        var sensorInfo = Sensor.getInfo();
        var yAccel = 0;
        if (sensorInfo has :accel && sensorInfo.accel != null) {
            yAccel = sensorInfo.accel[1];
        }
        else {
            yAccel = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_yAcc_i", {"data" => [yAccel.toNumber()]}, options, method(:onReceive2));
    }

    //Heartrate
    function sensor3() {
        var sensorInfo = Sensor.getInfo();
        var hR = 0;
        if (sensorInfo has :heartRate && sensorInfo.heartRate != null) {
            hR = sensorInfo.heartRate;
        }
        else {
            hR = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_hR_i", {"data" => [hR.toNumber()]}, options, method(:onReceive3));
    }

    //Altitude
    function sensor4() {
        var sensorInfo = Sensor.getInfo();
        var altitude = 0;
        if (sensorInfo has :altitude && sensorInfo.altitude != null) {
            altitude = sensorInfo.altitude;
        }
        else {
            altitude = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_alt_i", {"data" => [altitude.toFloat()]}, options, method(:onReceive4));
    }

    //Cadence
    function sensor5() {
        var sensorInfo = Sensor.getInfo();
        var cadence = 0;
        if (sensorInfo has :cadence && sensorInfo.cadence != null) {
            cadence = sensorInfo.cadence;
        }
        else {
            cadence = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_cad_i", {"data" => [cadence.toNumber()]}, options, method(:onReceive5));
    }

    //heading
    function sensor6() {
        var sensorInfo = Sensor.getInfo();
        var heading;
        if (sensorInfo has :heading && sensorInfo.heading != null) {
            heading = sensorInfo.heading;
        }
        else {
            heading = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_heading_i", {"data" => [heading.toFloat()]}, options, method(:onReceive6));
    }

    //magnetometer
    function sensor7() {
        var sensorInfo = Sensor.getInfo();
        var xMag;
        if (sensorInfo has :mag && sensorInfo.mag != null) {
            xMag = sensorInfo.mag[0];
        }
        else {
            xMag = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_xMag_i", {"data" => [xMag.toNumber()]}, options, method(:onReceive7));
    }

    //magnetometer
    function sensor8() {
        var sensorInfo = Sensor.getInfo();
        var yMag;
        if (sensorInfo has :mag && sensorInfo.mag != null) {
            yMag = sensorInfo.mag[1];
        }
        else {
            yMag = 1;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_yMag_i", {"data" => [yMag.toNumber()]}, options, method(:onReceive8));
    }

    //magnetometer
    function sensor9() {
        var sensorInfo = Sensor.getInfo();
        var zMag;
        if (sensorInfo has :mag && sensorInfo.mag != null) {
            zMag = sensorInfo.mag[2];
        }
        else {
            zMag = 2;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_zMag_i", {"data" => [zMag.toNumber()]}, options, method(:onReceive9));
    }

    //Power
    function sensor10() {
        var sensorInfo = Sensor.getInfo();
        var power;
        if (sensorInfo has :power && sensorInfo.power != null) {
            power = sensorInfo.power;
        }
        else {
            power = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_power_i", {"data" => [power.toNumber()]}, options, method(:onReceive10));
    }

    //Pressure
    function sensor11() {
        var sensorInfo = Sensor.getInfo();
        var pressure;
        if (sensorInfo has :pressure && sensorInfo.pressure != null) {
            pressure = sensorInfo.pressure;
        }
        else {
            pressure = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_pressure_i", {"data" => [pressure.toFloat()]}, options, method(:onReceive11));
    }

    //Speed
    function sensor12() {
        var sensorInfo = Sensor.getInfo();
        var speed;
        if (sensorInfo has :speed && sensorInfo.speed != null) {
            speed = sensorInfo.speed;
        }
        else {
            speed = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_speed_i", {"data" => [speed.toFloat()]}, options, method(:onReceive12));
    }

    //Temperature
    function sensor13() {
        var sensorInfo = Sensor.getInfo();
        var temp;
        if (sensorInfo has :temp && sensorInfo.temp != null) {
            temp = sensorInfo.temp;
        }
        else {
            temp = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_temp_i", {"data" => [temp.toNumber()]}, options, method(:onReceive13));
    }

    //Position
    function sensor14() {
        var positionInfo = Position.getInfo();
        var latitude;
        if (positionInfo has :position && positionInfo.position != null) {
            latitude = positionInfo.position.toDegrees()[0];
        }
        else {
            latitude = 0;
        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_lat_i", {"data" => [latitude.toFloat()]}, options, method(:onReceive14));
    }

    //Position
    function sensor15() {
        var positionInfo = Position.getInfo();
        var longitude;
        if (positionInfo has :position && positionInfo.position != null) {
            longitude = positionInfo.position.toDegrees()[1];
        }
        else {
            longitude = 0;

        }
        Communications.makeWebRequest("https://1.iottalk.tw/watch_dashboard/w_long_i", {"data" => [longitude.toFloat()]}, options, method(:onReceive15));
    }


    function onReceive(responseCode, data) {
        System.println("1 requestCallback " + responseCode + ", data = " + data);
    }

    function onReceive1(responseCode, data) {
        System.println("1 requestCallback " + responseCode + ", data = " + data);
        sensor2();
    }

    function onReceive2(responseCode, data) {
        System.println("2 requestCallback " + responseCode + ", data = " + data);
        sensor3();
    }

    function onReceive3(responseCode, data) {
        System.println("3 requestCallback " + responseCode + ", data = " + data);
        sensor4();
    }

    function onReceive4(responseCode, data) {
        System.println("4 requestCallback " + responseCode + ", data = " + data);
        sensor5();
    }
    
    function onReceive5(responseCode, data) {
        System.println("5 requestCallback " + responseCode + ", data = " + data);
        sensor6();
    }

    function onReceive6(responseCode, data) {
        System.println("6 requestCallback " + responseCode + ", data = " + data);
        sensor7();
    }

    function onReceive7(responseCode, data) {
        System.println("7 requestCallback " + responseCode + ", data = " + data);
        sensor8();
    }

    function onReceive8(responseCode, data) {
        System.println("8 requestCallback " + responseCode + ", data = " + data);
        sensor9();
    }

    function onReceive9(responseCode, data) {
        System.println("9 requestCallback " + responseCode + ", data = " + data);
        sensor10();
    }

    function onReceive10(responseCode, data) {
        System.println("10 requestCallback " + responseCode + ", data = " + data);
        sensor11();
    }
        function onReceive11(responseCode, data) {
        System.println("11 requestCallback " + responseCode + ", data = " + data);
        sensor12();
    }

    function onReceive12(responseCode, data) {
        System.println("12 requestCallback " + responseCode + ", data = " + data);
        sensor13();
    }  

    function onReceive13(responseCode, data) {
        System.println("13 requestCallback " + responseCode + ", data = " + data);
        sensor14();
    }

    function onReceive14(responseCode, data) {
        System.println("14 requestCallback " + responseCode + ", data = " + data);
        sensor15();
    }
        function onReceive15(responseCode, data) {
        System.println("15 requestCallback " + responseCode + ", data = " + data);
        sensor1();
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
