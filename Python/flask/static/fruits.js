var fruits = {Apples: 0, Oranges: 0, Pears: 0}
function add(fruit, n){
    fruits[fruit] += n
    console.log(fruits)
    document.getElementById(fruit).innerHTML = fruit + ': ' + fruits[fruit]
}

function remove(fruit, n){
    if (fruits[fruit] == 0){
        console.log(fruits) 
        document.getElementById(fruit).innerHTML = fruit + ': ' + fruits[fruit]
        return
    }
    if (fruits[fruit] < n){
        fruits[fruit] = 0
        console.log(fruits) 
        document.getElementById(fruit).innerHTML = fruit + ': ' + fruits[fruit]
        return
    }
    fruits[fruit] -= n 
    console.log(fruits) 
    document.getElementById(fruit).innerHTML = fruit + ': ' + fruits[fruit]
}

function save(){
    var xhr = new XMLHttpRequest()
    xhr.open("POST", '/save', true)
    xhr.setRequestHeader('Content-Type', 'application/json')
    xhr.send(JSON.stringify(fruits))
}  
