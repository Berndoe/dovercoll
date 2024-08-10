<!-- update Collector modal -->

<div class="modal fade trial" id="updateCollector<?php echo $collector['uid'];?>" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="update_collector" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="collectorModal">Update Collector</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="" method="POST">
                    <input class="form-control" type="hidden" name="collector_Id" autocomplete="off" value="<?php echo $collector['uid'];?>">
                    <input class="form-control" type="text" name="first_name" autocomplete="off" value="<?php echo $collector['first_name'];?>" placeholder="First Name"><br>
                    <input class="form-control" type="text" name="last_name" autocomplete="off" value="<?php echo $collector['last_name'];?>" placeholder="Last Name"><br>
                    <input class="form-control" type="email" name="email" autocomplete="off" value="<?php echo $collector['email'];?>" placeholder="Email"><br>
                    <input class="form-control" type="text" name="phone_number" autocomplete="off" value="<?php echo $collector['phone_number']; ?>" placeholder="Phone Number"><br>

            </div>
            <div class="d-grid gap-2 col-11 mx-auto" style="margin-top: 10; margin-left:30">
                <button type="button" class="btn btn-secondary option" data-dismiss="modal">Back</button>
                <button type="submit" name="update_collector" class="btn btn-primary" onclick="check()">Update Collector</button>
            </div><br>
            </form>
        </div>
    </div>
</div>

<?php

if (isset($_POST['update_collector'])) {
    $collector_id = $_POST['collector_Id'];
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $phone_number = $_POST['phone_number'];

    $data = array(
        'first_name' => $first_name,
        'last_name' => $last_name,
        'email' => $email,
        'phone_number' => $phone_number
    );

    // Convert data to JSON
    $data_json = json_encode($data);

    // Define API URL
    $url = 'http://127.0.0.1:5000/collectors/' . $collector_id;

    // Call API function with PUT method
    $response = callAPI('PUT', $url, $data);

    // Handle the response
    if ($response) {
        echo "<script>
            alert('Collector updated successfully');
            window.location.href = 'Collectors.php';
        </script>";
    } else {
        echo "<script>
            alert('Failed to update collector. Please try again later.');
            window.location.href = 'Collectors.php';
        </script>";
    }
}
?>



