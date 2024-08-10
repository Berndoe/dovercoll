 <!-- Delete assets modal -->
 <div class="modal fade" id="del_collector<?php echo $collector['uid']?>" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="del_collector" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="assetModal">Delete Collector</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body" style="text-align: center;">
        <form action="" method="POST">
        <input type="hidden" name="uid" value="<?php echo $collector['uid'];?>">
            Are you sure you want to delete this record?       
            <div class="d-grid gap-2 col-11 mx-auto" style="margin-top: 10;">
                <button type="submit" class="btn btn-primary delBtn" id="delete_collector" name="delete_collector">Yes</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal" style="margin-left: -2;">No</button>
            </div>
        </form>
        </div>
      </div>
    </div>
    </div>

    <?php

if (isset($_POST['delete_collector'])) {
    $collector_id = $_POST['uid'];

    // Define API URL
    $url = 'http://127.0.0.1:5000/collectors/' .$collector_id;

    // Call API function with PUT method
    $response = callAPI('DELETE', $url);
    $http_code = $response['status_code'];

    // Handle the response
    if ($http_code == 200) {
        echo "<script>
            alert('Collector deleted successfully');
            window.location.href = 'Collectors.php';
        </script>";
    } else {
        echo "<script>
            alert('Failed to delete collector. Please try again later.');
            window.location.href = 'Collectors.php';
        </script>";
    }
}

?>