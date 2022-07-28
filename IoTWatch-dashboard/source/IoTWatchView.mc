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
    var string_HR;

    //Fill in this variable with the time interval in ms that you want to use for submitting data. Lower values will cause more calls so will cost more!
    var timer = 20000;
    
    function initialize() {
        View.initialize();
        register();
        // Set up a timer
        dataTimer.start(method(:timerCallback), timer, true);
    }

    function register() {
        var params = {
            "profile" =>
            {
                "d_name" => "watch_dashboard",
                "dm_name" => "watch_dashboard",
                "u_name" => "yb",
                "is_sim" => false,
                "df_list" => ["watch-altitude-i", "watch-cadence-i", "watch-hR-i", "watch-heading-i", "watch-lat-i", 
                            "watch-long-i", "watch-power-i", "watch-pressure-i", "watch-speed-i", "watch-temp-i", 
                            "watch-xAcc-i", "watch-xMag-i", "watch-yAcc-i", "watch-yMag-i", "watch-zMag-i",
                            "watch-altitude-o", "watch-cadence-o", "watch-hR-o", "watch-heading-o", "watch-lat-o",
                            "watch-long-o", "watch-power-o", "watch-pressure-o", "watch-speed-o", "watch-temp-o",
                            "watch-xAcc-o", "watch-xMag-o", "watch-yAcc-o", "watch-yMag-o", "watch-zMag-o"]
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
        var responseCallback = method(:onReceive);
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard", params, options, method(:onReceive));
    }
    
    function timerCallback() {
        var sensorInfo = Sensor.getInfo();
        var positionInfo = Position.getInfo();
        var xAccel = 0;
        var yAccel = 0;
        var hR = 0;
        var altitude = 0;
        var cadence = 0;
        var heading = 0;
        var xMag = 0;
        var yMag = 0;
        var zMag = 0;
        var power = 0;
        var pressure = 0;
        var speed = 0;
        var temp = 0;
        var latitude = 0;
        var longitude = 0;

        var headers = {
            "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON
        };
        var options = {
            :headers => headers,
            :method => Communications.HTTP_REQUEST_METHOD_PUT,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_TEXT_PLAIN
        };
    
        //Collect Data
        //Accelerometer
        if (sensorInfo has :accel && sensorInfo.accel != null) {
            var accel = sensorInfo.accel;
            xAccel = accel[0];
            yAccel = accel[1];
        }
        else {
            xAccel = 0;
            yAccel = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-xAcc-i", {"data" => [xAccel.toNumber()]}, options, method(:onReceive));
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-yAcc-i", {"data" => [yAccel.toNumber()]}, options, method(:onReceive));

        //Heartrate
        if (sensorInfo has :heartRate && sensorInfo.heartRate != null) {
            hR = sensorInfo.heartRate;
        }
        else {
            hR = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-hR-i", {"data" => [hR.toNumber()]}, options, method(:onReceive));

        //Altitude
        if (sensorInfo has :altitude && sensorInfo.altitude != null) {
            altitude = sensorInfo.altitude;
        }
        else {
            altitude = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-altitude-i", {"data" => [altitude.toFloat()]}, options, method(:onReceive));

        //Cadence
        if (sensorInfo has :cadence && sensorInfo.cadence != null) {
            cadence = sensorInfo.cadence;
        }
        else {
            cadence = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-cadence-i", {"data" => [cadence.toNumber()]}, options, method(:onReceive));

        //heading
        if (sensorInfo has :heading && sensorInfo.heading != null) {
            heading = sensorInfo.heading;
        }
        else {
            heading = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-heading-i", {"data" => [heading.toFloat()]}, options, method(:onReceive));

        //magnetometer
        if (sensorInfo has :mag && sensorInfo.mag != null) {
            var mag = sensorInfo.mag;
            xMag = mag[0];
            yMag = mag[1];
            zMag = mag[2];
        }
        else {
            xMag = 0;
            yMag = 1;
            zMag = 2;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-xMag-i", {"data" => [xMag.toNumber()]}, options, method(:onReceive));
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-yMag-i", {"data" => [yMag.toNumber()]}, options, method(:onReceive));
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-zMag-i", {"data" => [zMag.toNumber()]}, options, method(:onReceive));

        //Power
        if (sensorInfo has :power && sensorInfo.power != null) {
            power = sensorInfo.power;
        }
        else {
            power = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-power-i", {"data" => [power.toNumber()]}, options, method(:onReceive));

        //Pressure
        if (sensorInfo has :pressure && sensorInfo.pressure != null) {
            pressure = sensorInfo.pressure;
        }
        else {
            pressure = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-pressure-i", {"data" => [pressure.toFloat()]}, options, method(:onReceive));

        //Speed
        if (sensorInfo has :speed && sensorInfo.speed != null) {
            speed = sensorInfo.speed;
        }
        else {
            speed = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-speed-i", {"data" => [speed.toFloat()]}, options, method(:onReceive));

        //Temperature
        if (sensorInfo has :temp && sensorInfo.temp != null) {
            temp = sensorInfo.temp;
        }
        else {
            temp = 0;
        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-temp-i", {"data" => [temp.toNumber()]}, options, method(:onReceive));

        //Position
        if (positionInfo has :position && positionInfo.position != null) {
            var location = positionInfo.position.toDegrees();
            latitude = location[0];
            longitude = location[1];
        }
        else {
            latitude = 0;
            longitude = 0;

        }
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-lat-i", {"data" => [latitude.toFloat()]}, options, method(:onReceive));
        Communications.makeWebRequest("https://demo.iottalk.tw/watch_dashboard/watch-long-i", {"data" => [longitude.toFloat()]}, options, method(:onReceive));


        // Send the data to the REST API
        // Communications.makeWebRequest ("https://demo.iottalk.tw/IoTWatch/IoTWatch-i", params, options, method(:onReceive));
        
    }
        
        function onReceive(responseCode, data) {
            System.println("requestCallback " + responseCode + ", data = " + data);
            // WatchUi.requestUpdate();
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
