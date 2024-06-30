# Tark Test Task

[Download .apk](https://drive.google.com/file/d/1T-z5CaaFJRgVaeoaRGn8yyU98uB-yMbk/view?usp=sharing)

## Features

- List GitHub users, fetched over GitHub API
- Scroll down to load more users
- Switch between tabs to see lists of users with the first letter of their username being in range of the corresponding tab's title
- Filter users by username by entering it in the textfield in the appbar

<img src="https://github.com/troublecatcher/tark_test_task/assets/91335963/12bd7992-5638-4c2b-a560-78ffdd0d236a" width="25%" height="25%"/>
<img src="https://github.com/troublecatcher/tark_test_task/assets/91335963/2c47025f-0f5b-4666-b2e6-0a93a04f748e" width="25%" height="25%"/>
<img src="https://github.com/troublecatcher/tark_test_task/assets/91335963/8639b8ff-5d0e-46d9-ac96-bcaac9a5350b" width="25%" height="25%"/>

## API Key usage

Public version of GitHub API is used by default. It has quite a small limit of requests for the amount of them being made in the application.
This is because GitHub doesn't allow to fetch users with their followers and following count being set, returning a URL to another endpoint instead. I'm pretty sure that was one of the key points of this task. It's adviced to place your own API key in 'assets/.env' like this:

key=[YOUR KEY]

## Implementation

The app is built with Data, Domain and Presentation layers.

There is an abstract repository, which remote repository implements, describing all network calls. Interceptor is used to include headers for each call.

The domain layer contains the profile model, the main bloc for fetching and managing the list of users and a separate cubit for telling the main bloc that the user is visible and ready to obtain the followers/following counters. Probably, that's not the best implementation regarding SOLID, but that's what I did for now.

The presentation layer contains the app's UI and is responsible for adding events to the domain. There is a query cubit for searching through the list.

The tabs' titles are described in list_pattern.dart and can be modified to hold different number of tabs or have different "from" and "to" letters. Assert is included so as to make sure the range is valid.

The appbar shows the user if the users are being loaded on the first launch.

#### Possible future advancements

- Add users caching using a local DB – quite a little effort is going to be required because of the architecture
- Make appbar show "Load more" status aswell
- Make user tiles clickable, leading to another page containing more detailed info
