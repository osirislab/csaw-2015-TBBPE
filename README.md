## GitHub AppSec Quiz

Hi! You're probably here because you're interested in an internship on the GitHub application security team. We made this little challenge to see how comfortable you are with web application security.

The Ruby on Rails application in this repository is a simple blogging framework. The admin user can publish blog posts and visitors to the site can vote on whether they like/dislike the posts.

### The challenge

There are a few vulnerabilities in this application. Find one of them and open a [pull request](https://help.github.com/articles/using-pull-requests/) to fix it.

### The application

There is a live version of this application running at [https://github-security-the-blog.herokuapp.com](https://github-security-the-blog.herokuapp.com). Please be gentle to this server. **Dont' run automated scans against it.**

You can also run this application locally. First, ensure that you have Git, Postgres, Ruby and the `bundler` Gem installed. Google can help with this, or you can open an issue on this repo asking for help. From there, you'll need to run

- `git clone https://github.com/SecurityInternship/vulnerable-app-{your-username}`
- `cd The-blog`
- `bundle install`
- `bundle exec rake db:migrate`

You can verify that everything is setup now by running the tests

- `bundle exec rake`

Now, you can start the local server by running

- `bundle exec rails server`

The application should now be running locally at [http://localhost:3000](http://localhost:3000).
