import '../css/bulls.css';
import "milligram";
import "phoenix_html";
import React from 'react';
import ReactDOM from 'react-dom';
import { useState, useEffect } from 'react';
import { ch_join, ch_push, ch_reset, store_input} from './socket';

function Bulls() {
    const [state, setState] = useState({
        guesses: [],
        result: [],
        userInput: "",
        message: "",
        lives: 8
    });
		
    useEffect(() => {
        ch_join(setState);
    });

    const makeGuess = () => {
        ch_push(state.userInput);
    }

	const updateGuess = ({ target }) => {
        store_input(target.value);
        setState({...state, userInput: target.value});
    }
	
    const resetGame = () => {
        ch_reset();
    }


	const keypress = (ev) => {
		if (ev.key === "Enter") {
			makeGuess();
		}
	}
    
    let rows = [];
    for (let i = 0; i < state.guesses.length; i++) {
        let guess1 = <td>{state.guesses[i]}</td>;
        let result1 = <td>{state.result[i]}</td>;
        rows.push(<tr>{[guess1, result1]}</tr>);
    }
 
    return (
		<div className = "App">
			<h1>4 Digits</h1>
			<h2> {state.message}</h2>
			<h3> Lives Remain: {state.lives} </h3>
			<input type="text" id="userinput"  value={state.userInput} maxLength="4" 
					onChange={updateGuess} onKeyPress={keypress}/>
			<p>	
			<button onClick={makeGuess}>Guess</button>
			<button onClick={resetGame}>Reset</button>
			</p>
			<table>
				<thead>
					<tr>
						<td>Guess</td>
						<td>Result</td>
					</tr>
				</thead>
				<tbody>
					{rows}
				</tbody>
			</table>
			<h4>Note: User has to input 4 unique digit numbers, with first letter to not be zero. NA means user had entered N number of digits correct in correct position , while NB means user had entered N number of digits correct but in wrong position</h4>
		</div>
	);
}
export default Bulls

	
