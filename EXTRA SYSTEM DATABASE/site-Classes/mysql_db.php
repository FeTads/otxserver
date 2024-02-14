<?php 
/**
 * @package Connection
 * @author Bruno Henrique da Silva
 * @version 1.0
 * @data 01/06/2016
 */
class Connection {


    /**
     * Instancia de conexao PDO
     * @var PDO
     */
    private static $instance = null;
    
    private static $DB_TYPE = 'mysql';

    
    /**
     * Host do banco de dados
     * @var string
     */
    private static $DB_HOST = 'localhost';

    /**
     * Usuario de conexao ao banco de dados
     * @var string
     */
    private static $DB_USER = 'root';

    
    /**
     * Senha de conexao ao banco de dados
     * @var string
     */
    private static $DB_PASS = 'SUA_SENHA';

    
    /**
     * Nome do banco de dados
     * @var string
     */
    private static $DB_NAME = 'NOME_BANCO';

    
    /**
     * Se a conexao deve ser persistente
     * @var boolean
     */
    protected static $persistent = false;

    /**
     * Retorna a instancia de conexao ao banco de dados
     * 
     * Caso a instancia de conexao ja exista, apenas a retorna, caso ainda
     * nao exista, cria a instancia e a retorna.
     * 
     * @return PDO
     */
    public static function getInstance() {
        if (!isset(self::$instance)) {
            //self::$instance = new PDO(self::$DB_TYPE . ':dbname=' . self::$DB_NAME. ';host=' . self::$DB_HOST . ';user=' . self::$DB_USER . ';password=' . self::$DB_PASS);
            //self::$instance->query("SET NAMES 'utf8'");
            //self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
			self::$instance = new PDO('mysql:host=' . self::$DB_HOST . ';dbname=' . self::$DB_NAME, self::$DB_USER, self::$DB_PASS);
        }
        return self::$instance;
    }

    /**
     * Fecha a instancia de conexao ao banco de dados
     */
    public static function close() {
        if (self::$instance !== null) {
            self::$instance = null;
        }
    }

}