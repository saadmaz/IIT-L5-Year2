// Var: Can be redeclared and updated | Container | Global, Function and Block
// Let: Can’t be redeclared but can update | Bottle of pills | Block
// Const: Can’t redeclare or Can’t update | Syringe vial | Block


// Handling variable
// Undefined: Not yet given a value but variable is there
// Null: No value
// Empty: An Empty object

// undefined variable
let order1
// empty variable
let order2 = ''
// null variable
let order3 = null


// type coercion | Truthiness
// explicit coercion
let null1 = 10
let n2 = '20'
let n3 = a + Number(b)

// implicit coercion
let n4 = 10
let n5 = '20'
let n6 = d + e

// Conditional (Ternary) Operator
// variablename = (condition) ? value1:value2

let g = 10
let h = 20
let i = g > h ? 'yes' : 'no'

// with if else
if (g > h) {
    i = 'yes'
} else {
    i = 'no'
}


// try catch finally example
try {
    // code block
    console.log('try block')
}
catch (err) {
    // code block
    console.log('catch block')
}
finally {
    // code block
    console.log('finally block')
}

// Transpiling
// Babel is a JavaScript compiler that takes your modern JavaScript code and returns browser-compatible JavaScript code.

// Spread syntax
// The spread syntax allows an iterable such as an array expression to be expanded in places where zero or more arguments stored.
let arr1 = [1, 2, 3]
let arr2 = [4, 5, 6]
let arr3 = [...arr1, ...arr2]

// Rest syntax
// The rest parameter syntax allows a function to accept an indefinite number of arguments as an array.
function sum(...args) {
    return args.reduce((a, b) => a + b, 0)
}

// Destructuring
// Destructuring is a JavaScript expression that makes it possible to unpack values from arrays, or properties from objects, into distinct variables.
let des = [1, 2, 3, 4]
let [a, b, c, d] = des


// Arrow function
// Normal function
hello = function () {
    return "Hello World!";
}
// Arrow function
hello = () => {
    return "Hello World!";
}

// map & filter & reduce
let arr = [1, 2, 3, 4]
let map = arr.map(item => item * 2) // [2, 4, 6, 8] | Appply the function to each item in the array
let fil = arr.filter(item => item % 2 === 0) // [2, 4]  | Filter out the items that don't meet the condition
let red = arr.reduce((a, b) => a + b, 0) // 10 | Reduce the array to a single value





// Promise
async function asyncPromise() {
    try {
        let result = await new Promise((resolve, reject) => {
            let a = 1 + 1
            if (a == 2) {
                // If true, call the resolve
                resolve('Success')
            } else {
                // If false, call the reject
                reject('Failed')
            }
        })
        console.log(result)
    } catch (error) {
        console.log(error)
    }
}

asyncPromise()

// async/await
async function asyncFunc() {
    //Promise that will resolve with the value 'done' after 1 second (1000 milliseconds)
    let promise = new Promise((resolve, reject) => {
        setTimeout(() => resolve('done'), 1000)
    })
    // Wait for the promise to resolve and store the result in the variable 'result'
    let result = await promise

    // Log the result to the console
    console.log(result)
}



