<!doctype html>
<html class="staticrypt-html">
<head>
    <meta charset="utf-8">
    <title>Margaux & Maxime</title>
    <link rel="icon" href="./favicon.png" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- do not cache this page -->
    <meta http-equiv="cache-control" content="max-age=0"/>
    <meta http-equiv="cache-control" content="no-cache"/>
    <meta http-equiv="expires" content="0"/>
    <meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT"/>
    <meta http-equiv="pragma" content="no-cache"/>

    <style>
        .staticrypt-hr {
            margin-top: 20px;
            margin-bottom: 20px;
            border: 0;
            border-top: 1px solid #eee;
        }
        .staticrypt-page {
            width: 360px;
            padding: 8% 0 0;
            margin: auto;
            box-sizing: border-box;
        }
        .staticrypt-form {
            position: relative;
            z-index: 1;
            background: #FFFFFF;
            max-width: 360px;
            margin: 0 auto 100px;
            padding: 45px;
            text-align: center;
            box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
        }
        .staticrypt-form input {
            outline: 0;
            background: #f2f2f2;
            width: 100%;
            border: 0;
            margin: 0 0 15px;
            padding: 15px;
            box-sizing: border-box;
            font-size: 14px;
        }
        .staticrypt-form .staticrypt-decrypt-button {
            text-transform: uppercase;
            outline: 0;
            background: #4CAF50;
            width: 100%;
            border: 0;
            padding: 15px;
            color: #FFFFFF;
            font-size: 14px;
            cursor: pointer;
        }
        .staticrypt-form .staticrypt-decrypt-button:hover, .staticrypt-form .staticrypt-decrypt-button:active, .staticrypt-form .staticrypt-decrypt-button:focus {
            background: #43A047;
        }
        .staticrypt-html {
            height: 100%;
        }
        .staticrypt-body {
            margin-bottom: 1em;
            background: #6D9F77;
            font-family: "Arial", sans-serif;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        .staticrypt-instructions {
            margin-top: -1em;
            margin-bottom: 1em;
        }
        .staticrypt-title {
            font-size: 1.5em;
        }
        .staticrypt-footer {
            position: fixed;
            height: 20px;
            font-size: 16px;
            padding: 2px;
            bottom: 0;
            left: 0;
            right: 0;
            margin-bottom: 0;
        }
        .staticrypt-footer p {
            margin: 2px;
            text-align: center;
            float: right;
        }
        .staticrypt-footer a {
            text-decoration: none;
        }
    </style>
</head>

<body class="staticrypt-body">
<div class="staticrypt-page">
    <div class="staticrypt-form">
        <div class="staticrypt-instructions">
            <p class="staticrypt-title">Margaux & Maxime</p>
            <p>{instructions}</p>
        </div>

        <hr class="staticrypt-hr">

        <form id="staticrypt-form" action="#" method="post">
            <input id="staticrypt-password"
                   type="password"
                   name="password"
                   placeholder="Mot de passe"
                   autofocus/>

            <input type="submit" class="staticrypt-decrypt-button" value="OK"/>
        </form>
    </div>

</div>


{crypto_tag}

<script>
    /**
     * Decrypt a salted msg using a password.
     * Inspired by https://github.com/adonespitogo
     */
    var keySize = 256;
    var iterations = 1000;
    var passphraseKey = 'mmpwd';
    function decrypt (encryptedMsg, pass) {
        var salt = CryptoJS.enc.Hex.parse(encryptedMsg.substr(0, 32));
        var iv = CryptoJS.enc.Hex.parse(encryptedMsg.substr(32, 32))
        var encrypted = encryptedMsg.substring(64);
        var key = CryptoJS.PBKDF2(pass, salt, {
            keySize: keySize/32,
            iterations: iterations
        });
        var decrypted = CryptoJS.AES.decrypt(encrypted, key, {
            iv: iv,
            padding: CryptoJS.pad.Pkcs7,
            mode: CryptoJS.mode.CBC
        }).toString(CryptoJS.enc.Utf8);
        return decrypted;
    }
    function openDocument(pass) {
        var encryptedMsg = '{encrypted}',
            encryptedHMAC = encryptedMsg.substring(0, 64),
            encryptedHTML = encryptedMsg.substring(64),
            decryptedHMAC = CryptoJS.HmacSHA256(encryptedHTML, CryptoJS.SHA256(pass).toString()).toString();
        if (decryptedHMAC !== encryptedHMAC) {
            alert('Mauvais mot de passe!');
            return;
        }
        localStorage.setItem(passphraseKey, pass);
        var plainHTML = decrypt(encryptedHTML, pass);
        document.write(plainHTML);
        document.close();
    }

    document.addEventListener('DOMContentLoaded',  function() {
        var savedPassphrase = localStorage.getItem(passphraseKey);
        if (savedPassphrase !== null) {
            openDocument(savedPassphrase);
        } else {
            document.getElementById('staticrypt-form').addEventListener('submit', function(e) {
                e.preventDefault();
                var passphrase = document.getElementById('staticrypt-password').value;
                openDocument(passphrase);
            });
        }
    });
</script>
</body>
</html>
