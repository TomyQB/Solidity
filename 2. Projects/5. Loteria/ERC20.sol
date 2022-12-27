// SPDX-License-Identifier: MIT
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;

import "./SafeMath.sol";

// Tomas ---> 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// Manuel ---> 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// Pedro ---> 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

interface IERC20 {
    // Devuelve la cantidad de tokens que hay
    function totalSupply() external view returns (uint256);

    // Devuelve la cantidad de tokens para una dirección indicada por parámetro (que tiene un usuario)
    function balanceOf(address account) external view returns (uint256);

    // Devuelve el numero de tokens que el "gastador" (spender) podrá gastar en nombre del propietario (owner)
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    //  Devuelve un valor bool resultado de la operación indicada
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    //  Devuelve un valor bool resultado de la operación indicada para el ejemplo disney
    function transfer(
        address client,
        address recipient,
        uint256 amount
    ) external returns (bool);

    // Devuelve un valor bool con el resultado de la operación de gasto
    function approve(address spender, uint256 amount) external returns (bool);

    //Devuelve un valor bool con el resultado de la operación de paso de una cantidad de tokens usando el método allowance()
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    // Evento que se debe emitir cuando una cantidad de tokens pase de un origen a un destino
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Evento que se debe emitir cuando se establece una asignación con el método allowance()
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract ERC20Basic is IERC20 {
    using SafeMath for uint256;

    string public constant name = "ERC20BlockchainAZ";
    string public constant symbol = "ERC";
    uint8 public constant decimals = 2;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 tokens
    );

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) public allowed;

    uint256 totalSupply_;

    constructor(uint256 _initialSupplay) public {
        totalSupply_ = _initialSupplay;
        balances[msg.sender] = totalSupply_;
    }

    // Consultar el total de tokens
    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    // Incrementar el total de tokens
    function increaseTotalSupply(uint256 _newTokensAmount) public {
        totalSupply_ += _newTokensAmount;
        balances[msg.sender] += _newTokensAmount;
    }

    // Consultar los tokens que tengo
    function balanceOf(address _tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[_tokenOwner];
    }

    // Consultar los tokens que tiene un delegado
    function allowance(address _owner, address _delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[_owner][_delegate];
    }

    // Transferencia
    function transfer(address _recipient, uint256 _numTokens)
        public
        override
        returns (bool)
    {
        // Comprobar que tengo tokens suficientes
        require(_numTokens <= balances[msg.sender]);

        // Restar tokens de mi cuenta y sumar a la del recipient
        balances[msg.sender] = balances[msg.sender].sub(_numTokens);
        balances[_recipient] = balances[_recipient].add(_numTokens);

        // Comunicar a la blockchain de las partes que han participado en la transacción y la cantidad de la misma
        emit Transfer(msg.sender, _recipient, _numTokens);

        return true;
    }

    // Transferencia disney
    function transfer(
        address _client,
        address _recipient,
        uint256 _numTokens
    ) public override returns (bool) {
        // Comprobar que tengo tokens suficientes
        require(_numTokens <= balances[_client]);

        // Restar tokens de mi cuenta y sumar a la del recipient
        balances[_client] = balances[_client].sub(_numTokens);
        balances[_recipient] = balances[_recipient].add(_numTokens);

        // Comunicar a la blockchain de las partes que han participado en la transacción y la cantidad de la misma
        emit Transfer(_client, _recipient, _numTokens);

        return true;
    }

    function approve(address _delegate, uint256 _numTokens)
        public
        override
        returns (bool)
    {
        // Doy permiso a un delegate para que pueda gastar un numero determinado de tokens
        allowed[msg.sender][_delegate] = _numTokens;

        // Comunicar a la blockchain de la operación anterior
        emit Approval(msg.sender, _delegate, _numTokens);

        return true;
    }

    function transferFrom(
        address _owner,
        address _recipient,
        uint256 _numTokens
    ) public override returns (bool) {
        // Comprobar que tengo tokens suficientes
        require(_numTokens <= balances[_owner]);
        // Comprobar que el delegado tiene tokens suficientes
        require(
            _numTokens <= allowed[_owner][msg.sender],
            "El delegado no tiene tokens suficientes"
        );

        // Restar tokens de mi cuenta y sumar a la del recipient
        balances[_owner] = balances[_owner].sub(_numTokens);
        allowed[_owner][msg.sender] = allowed[_owner][msg.sender].sub(
            _numTokens
        );
        balances[_recipient] = balances[_recipient].add(_numTokens);

        // Comunicar a la blockchain de las partes que han participado en la transacción y la cantidad de la misma
        emit Transfer(msg.sender, _recipient, _numTokens);

        return true;
    }
}
