import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'chat_messages.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE conversations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversationText TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        sender TEXT,
        timestamp INTEGER,
        conversationId INTEGER
        )
    ''');

    insertConversation(Conversation(id: 0, conversationText: "Default"));
    //   conversationId INTEGER,
    //   FOREIGN KEY (conversationId) REFERENCES conversations (id)
    // )
  }

  Future<int> insertConversation(Conversation conversation) async {
    final db = await database;
    return await db.insert('conversations', conversation.toMap());
  }

  Future<List<Conversation>> getConversations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('conversations');
    return List.generate(maps.length, (i) {
      return Conversation(
        id: maps[i]['id'],
        conversationText: maps[i]['conversationText'],
      );
    });
  }

  Future<int> insertMessage(Message message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessages(int conversationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
    );
    return List.generate(maps.length, (i) {
      return Message(
        id: maps[i]['id'],
        conversationId: maps[i]['conversationId'],
        content: maps[i]['content'],
        sender: maps[i]['sender'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  Future<int> deleteConversation(int conversationId) async {
    final db = await database;
    await db.delete(
      'conversations',
      where: 'id = ?',
      whereArgs: [conversationId],
    );
    return await db.delete(
      'messages',
      where: 'conversationId = ?',
      whereArgs: [conversationId],
    );
  }

  Future<int> deleteMessages(int id) async {
    final db = await database;
    return await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Conversation {
  final int id;
  final String conversationText;

  Conversation({required this.id, required this.conversationText});

  Map<String, dynamic> toMap() {
    return {
      'conversationText': conversationText,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'],
      conversationText: map['conversationText'],
    );
  }
}

class Message {
  final int id;
  final String content;
  final String sender;
  final int timestamp;
  final int conversationId;

  Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.conversationId,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'sender': sender,
      'timestamp': timestamp,
      'conversationId': conversationId,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      content: map['content'],
      sender: map['sender'],
      timestamp: map['timestamp'],
      conversationId: map['conversationId'],
    );
  }
}
