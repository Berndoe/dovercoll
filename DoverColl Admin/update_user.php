<!-- update User modal -->

<div class="modal fade trial" id="updateUser<?php echo $user['uid'];?>" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="update_user" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="userModal">Update User</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="" method="POST">
                    <input class="form-control" type="hidden" name="user_Id" autocomplete="off" value="<?php echo $user['uid'];?>">
                    <input class="form-control" type="text" name="first_name" autocomplete="off" value="<?php echo $user['first_name'];?>" placeholder="First Name"><br>
                    <input class="form-control" type="text" name="last_name" autocomplete="off" value="<?php echo $user['last_name'];?>" placeholder="Last Name"><br>
                    <input class="form-control" type="email" name="email" autocomplete="off" value="<?php echo $user['email'];?>" placeholder="Email"><br>
                    <input class="form-control" type="text" name="phone_number" autocomplete="off" value="<?php echo $user['phone_number']; ?>" placeholder="Phone Number"><br>

            </div>
            <div class="d-grid gap-2 col-11 mx-auto" style="margin-top: 10; margin-left:30">
                <button type="button" class="btn btn-secondary option" data-dismiss="modal">Back</button>
                <button type="submit" name="update_user" class="btn btn-primary" onclick="check()">Update User</button>
            </div><br>
            </form>
        </div>
    </div>
</div>

<?php

if (isset($_POST['update_user'])) {
    $user_id = $_POST['user_Id'];
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
    $url = 'http://127.0.0.1:5000/users/' . $user_id;

    // Call API function with PUT method
    $response = callAPI('PUT', $url, $data);


    // Handle the response
    if ($response) {
        echo "<script>
            alert('User updated successfully');
            window.location.href = 'Users.php';
        </script>";
    } else {
        echo "<script>
            alert('Failed to update user. Please try again later.');
            window.location.href = 'Users.php';
        </script>";
    }
}
?>



