<?php
include "API.php";
session_start();

// API call to fetch bookings
$response = callAPI('GET', 'http://127.0.0.1:5000/bookings');
$bookingData = json_decode($response['response'], true);

if (isset($bookingData['bookings'])) {
    $bookings = $bookingData['bookings'];
} else {
    $bookings = [];
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Booking Details</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js"></script>
    
    <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=yes">
    <style>
        .table-container {
          margin-top: 40px;
            margin-left: 300px;
            margin-right: 300px;
        }
        .navbar-nav {
            flex-direction: row;
        }
        .nav-item {
            margin-left: 150px;
        }
    </style>
</head>

<body>


<header>
    <!-- navigation bar content -->
    <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #0298cf;">
        <a class="navbar-brand" href="index.php" style="color: white;">DoverColl Admin</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" 
        aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
            <ul class="navbar-nav">
                <li class="nav-item active">
                    <a class="nav-link" href="Users.php" style="color: white;">Users <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="Collectors.php" style="color: white;">Collectors</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="Bookings.php" style="color: white;">Bookings</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="Bins.php" style="color: white;">Bins</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="Sensors.php" style="color: white;">Sensors</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.php" style="color: white;">Log Out</a>
                </li>
            </ul>
        </div>
    </nav>
</header> 

    <div class="container table-container">
        <nav class="navbar navbar-light bg-light justify-content-between">
            <a class="navbar-brand" style="font-size: 25px;">Bookings</a>
        </nav>

        <table class="table table-hover" id="booking_table">
            <thead class="thead-light" style="text-align: center;">
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Booking ID</th>
                    <th scope="col">User ID</th>
                    <th scope="col">Collector ID</th>
                    <th scope="col">Number of Bins</th>
                    <th scope="col">Price</th>
                    
                </tr>
            </thead>
            <tbody>
                <?php 
                $i = 1;
                foreach ($bookings as $booking): 
                ?>
                <tr style="text-align: center;">
                    <td scope="row"><?php echo $i++; ?></td>
                    <td scope="row"><?php echo $booking['booking_id']; ?></td>
                    <td scope="row"><?php echo $booking['user_id']; ?></td>
                    <td scope="row"><?php echo $booking['collector_id']; ?></td>
                    <td scope="row"><?php echo $booking['number_of_bins']; ?></td>
                    <td scope="row"><?php echo $booking['price']; ?></td>
                    
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>   

</body>
</html>
