# 00 Hello Ethernaut


#### Start
#### Open Developer Tools (F12)

- (1) type `await contract.info()` 


--------> you will see a message `'You will find what you need in info1().'`
- (2) type  `await contract.info1()`


--------> you will see a message `'Try info2(), but with "hello" as a parameter.'` 
- (3) type  `await contract.info2("hello")`


--------> you will see a message `'The property infoNum holds the number of the next info method to call.'` 
- (4) type  
```
let message = await contract.infoNum()
message.toString()
```


--------> you will see a message `'42'` 
- (5) type  `await contract.info42()`



--------> you will see a message `'theMethodName is the name of the next method.'` 
- (6) type  `await contract.theMethodName()`


--------> you will see a message `'The method name is method7123949.'` 
- (7) type  `await contract.method7123949()`


--------> you will see a message `'If you know the password, submit it to authenticate().'` 

Now we need to find the password. We will use the contract.abi command to see what functions are available. 

- (8) type  `await contract.abi`


--------> you will see a message 
```
(11) [{…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}, {…}]
0
: 
{inputs: Array(1), stateMutability: 'nonpayable', type: 'constructor', constant: undefined, payable: undefined}
1
: 
{inputs: Array(1), name: 'authenticate', outputs: Array(0), stateMutability: 'nonpayable', type: 'function', …}
2
: 
{inputs: Array(0), name: 'getCleared', outputs: Array(1), stateMutability: 'view', type: 'function', …}
3
: 
{inputs: Array(0), name: 'info', outputs: Array(1), stateMutability: 'pure', type: 'function', …}
4
: 
{inputs: Array(0), name: 'info1', outputs: Array(1), stateMutability: 'pure', type: 'function', …}
5
: 
{inputs: Array(1), name: 'info2', outputs: Array(1), stateMutability: 'pure', type: 'function', …}
6
: 
{inputs: Array(0), name: 'info42', outputs: Array(1), stateMutability: 'pure', type: 'function', …}
7
: 
{inputs: Array(0), name: 'infoNum', outputs: Array(1), stateMutability: 'view', type: 'function', …}
8
: 
{inputs: Array(0), name: 'method7123949', outputs: Array(1), stateMutability: 'pure', type: 'function', …}
9
: 
{inputs: Array(0), name: 'password', outputs: Array(1), stateMutability: 'view', type: 'function', …}
10
: 
{inputs: Array(0), name: 'theMethodName', outputs: Array(1), stateMutability: 'view', type: 'function', …}

```
Obj array 9 is a password function and is view , so we'll try calling

- (9) type  `await contract.password()`


--------> you will see a message `'ethernaut0'` 

Finally got the password

- (10) type  `await contract.authenticate('ethernaut0')` and confirm transaction
- (11) Click button  `Submit instance` and confirm transaction

# !!! we passed !!!


