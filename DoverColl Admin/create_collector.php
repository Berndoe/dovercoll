<div class="modal fade" id="new_collector" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="new_collector" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title text-center" id="collectorModal">New Collector</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
            <form action="" method="POST">
                <input class="form-control" type="text" name="first_name" autocomplete="on" placeholder="First name" required><br>
                <input class="form-control" type="text" name="last_name" autocomplete="on" placeholder="Last name" required><br>
                <input class="form-control" type="email" name="email" autocomplete="on" placeholder="Email" required><br>
                <input class="form-control" type="text" name="phone_number" autocomplete="on" placeholder="Phone Number" required><br>          
                <input class="form-control" type="password" name="password" autocomplete="on" placeholder="Password" required><br>          
                <input class="form-control" type="number" autocomplete="on" name="rating" placeholder="Rating"><br>

          <div class="d-grid gap-2 col-12 mx-auto" style="margin-top: 10px;">
            <button type="button" class="btn btn-secondary btn-block" data-dismiss="modal">Back</button>
            <button type="submit" class="btn btn-primary btn-block" name="insert_collector">Add Collector</button>
          </div>
      </div>
      </form>
    </div>
  </div>
</div>

<?php

if (isset($_POST['insert_collector'])) {
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $phone_number = $_POST['phone_number'];
    $rating = $_POST['rating'];
    $password = $_POST['password'];

    $data = array(
        'first_name' => $first_name,
        'last_name' => $last_name,
        'email' => $email,
        'phone_number' => $phone_number,
        'rating' => $rating,
        'password' => $password
    );

    // Convert data to JSON
    $data_json = json_encode($data);

    // Define API URL
    $url = 'http://127.0.0.1:5000/collectors';

    // Call API function with PUT method
    $response = callAPI('POST', $url, $data);
    $http_code = $response['status_code'];

    // Handle the response
    if ($http_code == 201) {
        echo "<script>
            alert('Collector created successfully');
            window.location.href = 'Collectors.php';
        </script>";
    } else {
        echo "<script>
            alert('Failed to create collector. Please try again later.');
            window.location.href = 'Collectors.php';
        </script>";
    }
}
?>
