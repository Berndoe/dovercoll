<?php
include "API.php";
       session_start();
        
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Home</title>
    
</head>

 <style>
    /* header styling */
    .nav-item {
        margin-left: 200px;
        padding-left:50%;
        font-size: 18px;
    }

    .card {
      margin-top: 13%;
      display: flex;
      
    }

    .card-deck {
      padding-left: 120px;
      padding-right: 120px;
    }

    .number {
      font-size: 400%;
      font-weight: bolder;
    }

    .navbar-nav {
            flex-direction: row;
        }
        .nav-item {
            margin-left: 150px;
        }
 </style>

<body>
<header>
    <!-- navigation bar content  -->
    <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #0298cf;">
        <a class="navbar-brand" href="./Home Page.php" style="color: white;">DoverColl Admin</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
          <div class="navbar-nav">
            <a class="nav-item nav-link active" href="Users.php" style="color: white;">Users <span class="sr-only">(current)</span></a>
            <a class="nav-item nav-link" href="Collectors.php" style="color: white;">Collectors</a>
            <a class="nav-item nav-link" href="Bookings.php" style="color: white;">Bookings</a>
            <a class="nav-item nav-link" href="Bins.php" style="color: white;">Bins</a>
            <a class="nav-item nav-link" href="Sensors.php" style="color: white;">Sensors</a>
            <a class="nav-item nav-link" href="logout.php" style="color: white;">
              Log Out
            </a>
          </div>
        </div>
      </nav>
    </header>
    <!-- cards -->
    <?php
    $response = callAPI('GET', 'http://127.0.0.1:5000/users');
    $usersData = json_decode($response['response'], true);
    $number_of_users = count($usersData);

    $response = callAPI('GET', 'http://127.0.0.1:5000/collectors');
    $collectorsData = json_decode($response['response'], true);
    $number_of_collectors = count($collectorsData);

    $response = callAPI('GET', 'http://127.0.0.1:5000/bookings');
    $bookingData = json_decode($response['response'], true);
    $number_of_bookings = count($bookingData);

    $response = callAPI('GET', 'http://127.0.0.1:5000/users/history');
    $revenueData = json_decode($response['response'], true);
    $revenue = count($revenueData);
     
  ?>


    <div class="card-deck">   
      
      <!-- Number of users -->
      <div class="card">
        <div class="card-body">
          <p class="card-title">Number of Users</p>
          <p class="card-text number" style="color:#0298cf">
            <?php echo $number_of_users + $number_of_collectors; ?>
          </p>
        </div>
      </div>

      <!-- Paid salaries -->
      <div class="card">
        <div class="card-body">
          <p class="card-title">Number of Bookings</p>
          <p class="card-text number" style="color:crimson">
            <?php echo $number_of_bookings;?>
          </p>
        </div>
      </div>

      <!-- Number of assets -->
      <div class="card">
        <div class="card-body">
          <p class="card-title">Revenue</p>
          <p class="card-text number" style="color:green;">
            <?php echo 40; ?>
          </p>
        </div>
      </div>
  
  </div>

    <!-- Footer -->
    <footer class="page-footer font-small blue fixed-bottom" style="background-color: #0298cf">
        <div class="footer-copyright text-center py-3">
        <p style="color: white;">Copyright © 2024 DoverColl Admin- All Rights Reserved.</p>
        </div>  
    </footer>
      
</body>
</html>