<?php
    include "config.php";
    include "pagination.php";

    session_start();
    
    if (!isset($_SESSION['email']) || !isset($_SESSION['pass'])) {
      header("Location: index.php");
      exit();
  }
?>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Assets</title>
    <script src="search.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"/>
    <link rel="stylesheet" href="./Tables.css">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <script> searchAssetPosition('#assetTable') </script>
</head>

<header>
    <!-- navigation bar content  -->
    <nav class="navbar navbar-expand-lg navbar-light" style="background-color: #0298cf;">
        <a class="navbar-brand" href="Home Page.php" style="color: white;">Axon Employee Management System</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
          <div class="navbar-nav">
            <a class="nav-item nav-link active" href="Employee Page.php" style="color: white;">Employees <span class="sr-only">(current)</span></a>
            <a class="nav-item nav-link" href="Salary Page.php" style="color: white;">Salaries</a>
            <a class="nav-item nav-link" href="Asset Page.php" style="color: white;">Assets</a>
            <a class="nav-item nav-link" href="logout.php" style="color: white;">
              Log Out
            </a>
          </div>
        </div>
    </nav>
</header>
 
<body>
    <nav class="navbar navbar-light bg-light justify-content-between">
        <a class="navbar-brand" style="font-size: 25;font-family:Arial, Helvetica, sans-serif;">Assets</a>
        <div>
            <button class="new_button btn btn-outline" type="button" data-toggle="modal" data-target="#new_asset">New Asset</button>
        </div>
    </nav>
 
    <table class="table table-hover" id="assetTable" style="margin-top: -8px;">
        <thead class="thead-light" style="text-align:center;">
              <tr>
                   <th scope="col">#</th>
                   <th scope="col">Employee ID</th>
                   <th scope="col">First Name</th>
                   <th scope="col">Last Name</th>
                   <th scope="col">Asset</th>
                   <th scope="col">Action</th>
               </tr>
        </thead>

      <?php

        $asset_page_query = $conn->query("SELECT * FROM Employee, Assets
        WHERE Employee.asset_Id = Assets.asset_Id 
        ORDER BY first_name ASC LIMIT $start, $recordsPerPage;");

        $asset = $asset_page_query->fetch_all(MYSQLI_ASSOC);
      ?>
        
      <tbody>
          <?php $i = $start + 1; foreach ($asset as $row): ?>
          <tr>
              <td scope="row"><?php echo $i++;?></td>
              <td scope="row"><?php echo $row['employee_Id']?></td>
              <td scope="row"><?php echo $row['first_name']?></td>
              <td scope="row"><?php echo $row['last_name']?></td>
              <td scope="row"><?php echo $row['asset_name']?></td>
              <td scope="row">
                  <button class="btn btn-sm text-light edit" data-toggle="modal" data-target="#update_asset<?php echo $row['employee_Id']?>"><i class="fa-solid fa-pen-to-square"></i></button> 
                  <button class="btn btn-sm text-light delete" data-toggle="modal" data-target="#del_asset<?php echo $row['employee_Id']?>"><i class="fa-solid fa-trash"></i></button>
              </td> 
          </tr>
          <?php
             include "create_asset.php";
             include "delete_asset.php";
             include "update_asset.php"; 
          ?>
        <?php 
          endforeach; 
          $conn->close();
        ?>
      </tbody>
    </table>
      

         <!-- Pagination -->
         <nav style="margin-top:-20px;" id="asset_pagination">
            <ul class="pagination justify-content-end">
              <li class="page-item">
                <!-- Previous page -->
                <?php if ($currentPage > 1) {$prevPage = $currentPage - 1;} ?>

                <a class="page-link" href="Asset Page.php?page=<?php echo $prevPage; ?>" aria-label="Previous" >
                  <span aria-hidden="true">&laquo;</span>
                </a>

              </li>
              <?php 
                  for ($i=1; $i <= $totalPages; $i++):     
              ?>
              <li class="page-item">
                <a class="page-link" href="Asset Page.php?page=<?php echo $i; ?>"><?php echo $i; ?></a>
              </li>
              <?php endfor; ?>

              <!-- Next Page -->
              <?php if ($currentPage < $totalPagesAssets) {$nextPage = $currentPage + 1;} ?>
              <li class="page-item">
                <a class="page-link" href="Asset Page.php?page=<?php echo $nextPage; ?>" aria-label="Next">
                  <span aria-hidden="true">&raquo;</span>
                </a>
              </li>
            </ul>
        </nav>
 </body>
</html>