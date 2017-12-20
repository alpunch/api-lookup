import os

# The config class contains general settings that we want all environments to have by default.
class Config(object):
    """Parent configuration class."""
    # DEBUG : tells the app to run under debugging mode when set to True, allowing us to use the Flask debugger.
    # It also automagically reloads the application when it's updated.
    DEBUG = False
    CSRF_ENABLED = True
    # SECRET : is a random string of characters that's used to generate hashes that secure various things in an app.
    SECRET = os.getenv('SECRET')
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL')

# Other environment classes inherit from it and can be used to set settings that are unique to them.
class DevelopmentConfig(Config):
    """Configurations for Development."""
    DEBUG = True

class TestingConfig(Config):
    """Configurations for Testing, with a separate test database."""
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'postgresql://localhost/test_db'
    DEBUG = True

class StagingConfig(Config):
    """Configurations for Staging."""
    DEBUG = True

class ProductionConfig(Config):
    """Configurations for Production."""
    DEBUG = False
    TESTING = False

# Additionally, the dictionary "aap_config" is used to export the 4 envs we've specified.
# It's convenient to have it so that we can import the config under its name tag in future.
app_config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'staging': StagingConfig,
    'production': ProductionConfig,
}