class ApiEndpoints {
  ApiEndpoints._();
  static const String baseUrl = 'https://api.todoist.com/rest/v2';
  static const String token = 'e3c2e69cd271f222a12f399124b70485fd791cb7';
  // POST endpoint for creating a post
  static String createTask = '/tasks';
  static String createComment = '/comments';

  // GET endpoint for fetching posts
  static String getTask = '/tasks';
  // static String getComment = '/comment';
  // GET endpoint for fetching a single post
  static String updateTask(String tasktId) => '/tasks/$tasktId';
  static String getComment(String tasktId) => '/comments?task_id=$tasktId';

  // DELETE endpoint for deleting a post
  static String deleteTask(String tasktId) => '/tasks/$tasktId';
}

// comments?task_id=2995104339