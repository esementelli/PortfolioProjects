
let _max = -1;
let num ;
while (_max <= 0 || isNaN(_max))
{ 
    _max = Math.round(Number(prompt("Choose your maximum number,", "maximum number")));
}

num = Math.floor(Math.random()*_max) + 1;
console.log('Your maximun number is: '+ _max);
console.log('Random number: ' + num);

let trackGuess = [];
let numGuess = 0

function do_guess() {
    
    let guess = Number(document.getElementById("guess").value);
    let message = document.getElementById("message");

    if (trackGuess.includes(guess))
    {
        alert("You have guessed that already. Try again.")
    }

    else if(isNaN(guess)) {
    alert("That is not a number!");
    
    } 
    else if (guess < 1 || guess > _max) {
        alert("That number is not in range, try again.");

    }

    else if(guess<num) {
        message.innerHTML = "No, Try a Higher Number";
        trackGuess.push(guess);
        numGuess += 1;
    }
    else if(guess>num) {
        message.innerHTML= "No, Try a Lower Number";
        trackGuess.push(guess);
        numGuess += 1;
    }

     else {
            trackGuess.push(guess);
            message.innerHTML = "You Got It!";
            numGuess += 1;
            message.innerHTML += " It took you " + numGuess + " tries and your guesses were " + trackGuess.join(", ");
    

    }
}







