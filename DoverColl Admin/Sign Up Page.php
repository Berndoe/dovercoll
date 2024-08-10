<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
</head>
<style>
    .container {
        background-color: rgb(179, 75, 75);
        width: 490px;
        position: relative;
        margin-top: 12%;
        background-color: white;
        padding: 20px 60px 35px 60px;
        box-shadow: 0px 0px 10px 1px rgb(239, 235, 235);  
    
    }
</style>
<body>


<form action="sign_up_proc.php" method="post">
    <div class="container">
        <p style="font-size:20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; color: black;">Sign up with your email</p>

        <div style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;"><p>Already have an account? <a href="./index.php" style="text-decoration: none; color:blue;">Sign in</a></p></div>
        <input class="form-control" type="text" name="first_name" placeholder="First name" autocomplete="off" required><br>
        <input class="form-control" type="text" name="last_name" placeholder="Last name" autocomplete="off" required><br>
        <input class="form-control" type="email" name="email" placeholder="Email address" autocomplete="off" required><br>
        <input class="form-control" type="password" name="pass" placeholder="Password" autocomplete="off" required><br>            
        <div class="form-check">
            <input class="form-check-input" type="checkbox" id="checkBox" required>
            <label class="form-check-label" for="checkBox">I agree to the <a href="Terms and Conds.php" style="text-decoration: none;">Terms of Service and Privacy Policy</a></label>
        </div>
        <div class="d-grid gap-2 col-11 mx-auto" style="margin-top: 10;">
            <button class="btn btn-primary" name="create_admin" type="submit">Create account</button></a>
        </div><br>
        <!-- <p style="color:red;" type="hidden">Account already exists</p> -->
    </div>
</form> 
</body>
</html>


