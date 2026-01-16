# Setup Instructions

## Getting Your Todoist API Token

1. **Visit the Todoist App Management Console:**
   - Go to: https://developer.todoist.com/appconsole.html
   - Sign in with your Todoist account

2. **Create or Select an App:**
   - Click "Create new app" if you don't have one
   - Or select an existing app

3. **Copy Your API Token:**
   - Find the "API token" section
   - Copy the token (it looks like: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`)

4. **Configure the Token in the App:**
   - Open: `lib/core/config/app_config.dart`
   - Find the line: `const token = 'YOUR_TODOIST_API_TOKEN_HERE';`
   - Replace `YOUR_TODOIST_API_TOKEN_HERE` with your actual token
   - Example: `const token = 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';`

## Security Note

⚠️ **IMPORTANT:** Never commit your API token to version control!

The token file is already in `.gitignore` to prevent accidental commits. Always keep your tokens private.

## Verify Your Setup

After setting your token, run the app:

```bash
flutter run
```

If the token is valid, you should be able to:
- Fetch tasks from Todoist
- Create new tasks
- Update and delete tasks
- Add comments

If you see authentication errors, double-check that:
1. Your token is correctly pasted (no extra spaces)
2. Your token hasn't expired
3. You have the necessary permissions in your Todoist app settings
