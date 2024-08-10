<?php

session_start();

unset($_SESSION['email']);

unset($_SESSION['pass']);

echo "<script>
        alert('Successfully logged out');
        window.location.href = 'index.php';
      </script>";

?>