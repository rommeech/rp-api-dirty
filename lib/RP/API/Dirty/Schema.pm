package RP::API::Dirty::Schema;

use utf8;
use strict;
use warnings;
use Carp;

sub method { 'POST' }
sub mime_type { 'application/json' }

=head2 todo
Черновики
 - Получить черновик поста
 - Создать черновик поста
 - Удалить черновик поста
 - Изменить черновик поста
 - Опубликовать черновик
=cut

# ===============================================
#
#     Authentication
#
# ===============================================

sub auth_register {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/auth/register/',

    request_schema => <<'',
{
  "required": [
    "username",
    "password",
    "email",
    "gender"
  ],
  "properties": {
    "username": {
      "type": "string"
    },
    "gender": {
      "enum": [
        "male",
        "female"
      ],
      "type": "string"
    },
    "password": {
      "type": "string"
    },
    "email": {
      "type": "string"
    }
  },
  "title": "Register Request"
}

    response_schema => <<'',
{
  "properties": {
    "uid": {
      "type": "string"
    },
    "sid": {
      "type": "string"
    }
  },
  "title": "Auth Response"
}

}}

sub auth_login {{
	method => 'POST',
	url => 'https://dirty.ru/api/auth/login/',

	request_schema => <<'',
{
  "required": [
    "username",
    "password"
  ],
  "properties": {
    "username": {
      "type": "string"
    },
    "password": {
      "type": "string"
    }
  },
  "title": "Login Request"
}

	response_schema => <<'',
{
  "properties": {
    "uid": {
      "type": "string"
    },
    "sid": {
      "type": "string"
    }
  },
  "title": "Auth Response"
}

}};

sub auth_password_change {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/auth/password_change/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "password",
    "old_password"
  ],
  "properties": {
    "password": {
      "type": "string"
    },
    "old_password": {
      "type": "string"
    }
  },
  "title": "Password Change Request"
}

    response_schema => '',

}};

sub auth_password_reset {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/auth/password_reset/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "properties": {
    "username": {
      "type": "string"
    },
    "email": {
      "type": "string"
    }
  },
  "title": "Password Reset Request"
}

    response_schema => '',
}}

sub auth_social_login {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/auth/social/login/',

    request_schema => <<'',
{
  "required": [
    "access_token",
    "provider"
  ],
  "properties": {
    "access_token": {
      "type": "string"
    },
    "provider": {
      "type": "string"
    }
  },
  "title": "Social Login Request"
}

    response_schema => '',
}}

sub auth_social_register {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/auth/social/register/',

    request_schema => <<'',
{
  "required": [
    "username",
    "access_token",
    "provider"
  ],
  "properties": {
    "username": {
      "type": "string"
    },
    "access_token": {
      "type": "string"
    },
    "provider": {
      "type": "string"
    }
  },
  "title": "Social Register Request"
}

    response_schema => '',
}}

sub auth_social_connect {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/auth/social/connect/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "access_token",
    "provider"
  ],
  "properties": {
    "access_token": {
      "type": "string"
    },
    "provider": {
      "type": "string"
    }
  },
  "title": "Social Connect Request"
}

    response_schema => '',
}}

sub auth_social_disconnect {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/auth/social/disconnect/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "provider"
  ],
  "properties": {
    "provider": {
      "type": "string"
    }
  },
  "title": "Social Disconnect Request"
}

    response_schema => '',
}}


# ===============================================
#
#     Posts
#
# ===============================================

sub posts_list {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/posts/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "sorting": {
      "default": "hotness",
      "enum": [
        "rating",
        "hotness",
        "date_changed",
        "date_created"
      ],
      "type": "string",
      "description": "Сортировка"
    },
    "threshold_rating": {
      "type": "integer",
      "description": "Ограничение по рейтингу поста",
      "format": "int32"
    },
    "threshold_date": {
      "enum": [
        "week",
        "year",
        "day",
        "month"
      ],
      "type": "string",
      "description": "Ограничение по дате создания поста"
    },
    "exclude_post": {
      "type": "integer",
      "description": "Исключить пост с этим id из фида",
      "format": "int32"
    },
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Base Feed Request"
}

    #response_schema => '',
}}

sub post_get {{
    method          => 'GET',
    url             => 'https://dirty.ru/api/posts/{post_id}/',
    request_schema  => '',
    #response_schema => '',
}}

sub NOT_IMPLEMENTET_YET_post_create {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/posts/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema  => '',
    #response_schema => '',

}}

sub NOT_IMPLEMENTED_YET_post_delete {{
    method          => 'DELETE',
    url             => 'https://dirty.ru/api/posts/{post_id}/',
    request_schema  => '',
    #response_schema => '',
}}

sub NOT_IMPLEMENTED_YET_post_update {{
    method          => 'PATCH',
    url             => 'https://dirty.ru/api/posts/{post_id}/',
    request_schema  => '',
    #response_schema => '',
}}

sub post_votes {{
    method          => 'GET',
    url             => 'https://dirty.ru/api/posts/{post_id}/votes/',
    request_schema  => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Get Vote Post Request"
}

    #response_schema => '',
}}

sub post_vote {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/posts/{post_id}/vote/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "vote"
  ],
  "properties": {
    "vote": {
      "enum": [
        0,
        1,
        -1
      ],
      "type": "integer",
      "description": "Значение голоса",
      "format": "int32"
    }
  },
  "title": "Vote Post Request"
}

    #response_schema => '',
}}

sub post_mark_as_viewed {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/posts/{post_id}/view/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub post_favourite {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/posts/{post_id}/favourite/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub post_unfavourite {{
    method    => 'DELETE',
    url       => 'https://dirty.ru/api/posts/{post_id}/favourite/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub post_pin {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/posts/{post_id}/pin/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub post_unpin {{
    method    => 'DELETE',
    url       => 'https://dirty.ru/api/posts/{post_id}/pin/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub post_unpublish {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/posts/{post_id}/unpublish/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "properties": {
    "reason": {
      "type": "string"
    }
  },
  "title": "Un Publish Post Request"
}

    #response_schema => '',
}}

sub post_permissions {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/posts/{post_id}/permissions/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub domains_posts_list {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/domains/{domain_prefix}/posts/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "sorting": {
      "default": "hotness",
      "enum": [
        "rating",
        "hotness",
        "date_changed",
        "date_created"
      ],
      "type": "string",
      "description": "Сортировка"
    },
    "threshold_rating": {
      "type": "integer",
      "description": "Ограничение по рейтингу поста",
      "format": "int32"
    },
    "threshold_date": {
      "enum": [
        "week",
        "year",
        "day",
        "month"
      ],
      "type": "string",
      "description": "Ограничение по дате создания поста"
    },
    "exclude_post": {
      "type": "integer",
      "description": "Исключить пост с этим id из фида",
      "format": "int32"
    },
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Base Feed Request"
}

    #response_schema => '',
}}

sub domains_post_pinned {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/domains/{domain_prefix}/posts/pinned/',

    request_schema => '',

    #response_schema => '',
}}

# ===============================================
#
#     My things
#
# ===============================================

sub posts_subscriptions {{
    method => 'GET',
    url    => 'https://dirty.ru/api/posts/subscriptions/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "sorting": {
      "default": "hotness",
      "enum": [
        "rating",
        "hotness",
        "date_changed",
        "date_created"
      ],
      "type": "string",
      "description": "Сортировка"
    },
    "threshold_rating": {
      "type": "integer",
      "description": "Ограничение по рейтингу поста",
      "format": "int32"
    },
    "threshold_date": {
      "enum": [
        "week",
        "year",
        "day",
        "month"
      ],
      "type": "string",
      "description": "Ограничение по дате создания поста"
    },
    "exclude_post": {
      "type": "integer",
      "description": "Исключить пост с этим id из фида",
      "format": "int32"
    },
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Base Feed Request"
}

    #response_schema => '',
}}

sub my_profile {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_domains_related {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/domains/related/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_domains_subscribed {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/domains/subscribed/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_votes {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/votes/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/notifications/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications_unread {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/notifications/unread/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications_unread_count {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/notifications/unread/count/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications_unread_count_by_type {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/notifications/unread/count_by_type/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications_subscriptions {{
    method => 'POST',
    url    => 'https://dirty.ru/api/my/notifications/subscriptions/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "action",
    "type"
  ],
  "properties": {
    "action": {
      "enum": [
        "reset",
        "subscribe",
        "unsubscribe"
      ],
      "type": "string"
    },
    "type": {
      "type": "string"
    }
  },
  "title": "Base Update Notification Subscription Request"
}

    #response_schema => '',
}}

sub my_notifications_feed_settings {{
    method => 'GET',
    url    => 'https://dirty.ru/api/my/notifications/feed_settings/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications_feed_settings_change {{
    method => 'PATCH',
    url    => 'https://dirty.ru/api/my/notifications/feed_settings/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications_mark_read {{
    method => 'POST',
    url    => 'https://dirty.ru/api/my/notifications/mark_read/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

sub my_notifications_mark_read_one {{
    method => 'POST',
    url    => 'https://dirty.ru/api/my/notifications/{notification_id}/mark_read/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',
    #response_schema => '',
}}

# ===============================================
#
#     Comments
#
# ===============================================

sub posts_comments {{
    method => 'GET',
    url    => 'https://dirty.ru/api/posts/{post_id}/comments/',

    request_schema => <<'',
{
  "properties": {
    "sorting": {
      "default": "rating_tree",
      "enum": [
        "date_tree",
        "rating_tree"
      ],
      "type": "string",
      "description": "Метод сортировки комментариев"
    }
  },
  "title": "Get Post Comments Request"
}

    #response_schema => '',
}}

sub posts_comments_write {{
    method => 'POST',
    url    => 'https://dirty.ru/api/posts/{post_id}/comments/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "body"
  ],
  "properties": {
    "body": {
      "type": "string"
    },
    "parent_comment_id": {
      "type": "integer",
      "format": "int32"
    },
    "media_id": {
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Create Post Comment Request"
}

    #response_schema => '',
}}

sub comments {{
    method => 'GET',
    url    => 'https://dirty.ru/api/comments/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "body"
  ],
  "properties": {
    "body": {
      "type": "string"
    },
    "parent_comment_id": {
      "type": "integer",
      "format": "int32"
    },
    "media_id": {
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Create Post Comment Request"
}

    #response_schema => '',
}}

sub comments_sharing_image {{
    method => 'GET',
    url    => 'https://dirty.ru/api/comments/{comment_id}/sharing_image/',

    request_schema => '',

    #response_schema => '',
}}

sub comments_votes {{
    method => 'GET',
    url    => 'https://dirty.ru/api/comments/{comment_id}/votes/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Get Vote Comment Request"
}

    #response_schema => '',
}}

sub comments_vote {{
    method => 'GET',
    url    => 'https://dirty.ru/api/comments/{comment_id}/vote/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "vote"
  ],
  "properties": {
    "vote": {
      "enum": [
        0,
        1,
        -1
      ],
      "type": "integer",
      "description": "Значение голоса",
      "format": "int32"
    }
  },
  "title": "Vote Comment Request"
}

    #response_schema => '',
}}

# ===============================================
#
#     User
#
# ===============================================

sub users_bans {{
    method => 'GET',
    url    => 'https://dirty.ru/api/users/{login}/bans/',

    request_schema => '',

    #response_schema => '',
}}

sub users_posts {{
    method => 'GET',
    url    => 'https://dirty.ru/api/users/{login}/posts/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Base Paginated Request"
}

    #response_schema => '',
}}


sub users_posts_search {{
    method => 'GET',
    url    => 'https://dirty.ru/api/users/{login}/posts/search/',

    request_schema => '',

    #response_schema => '',
}}

sub users_comments {{
    method => 'GET',
    url    => 'https://dirty.ru/api/users/{login}/comments/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Base Paginated Request"
}

    #response_schema => '',
}}

sub users_comments_search {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/users/{login}/comments/search/',

    request_schema => <<'',

    #response_schema => '',
}}

sub users_domains {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/users/{login}/domains/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Base Paginated Request"
}

    #response_schema => '',
}}

sub users_favourites_posts {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/users/{login}/favourites/posts/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Base Paginated Request"
}

    #response_schema => '',
}}

sub users_ignore {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/users/{login}/ignore/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub users_unignore {{
    method    => 'DELETE',
    url       => 'https://dirty.ru/api/users/{login}/ignore/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub users_votes {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/users/{login}/votes/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "User Votes Request"
}

    #response_schema => '',
}}

# ===============================================
#
#     Subdomains
#
# ===============================================

sub domains {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/domains/',

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "q": {
      "type": "string",
      "description": "Поисковый запрос"
    },
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Domains Request"
}

    #response_schema => '',
}}

sub domains_create {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/domains/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub domains_get {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/domains/{domain_prefix}/',

    request_schema => '',

    #response_schema => '',
}}

sub domains_permissions {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/domains/{domain_id}/permissions/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub domains_ignore {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/domains/{domain_id}/ignore/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub domains_unignore {{
    method    => 'DELETE',
    url       => 'https://dirty.ru/api/domains/{domain_id}/ignore/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub domains_subscribe {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/domains/{domain_id}/subscribe/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub domains_unsubscribe {{
    method    => 'DELETE',
    url       => 'https://dirty.ru/api/domains/{domain_id}/subscribe/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub domains_related {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/my/domains/related/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub domains_subscribed {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/my/domains/subscribed/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "q": {
      "type": "string",
      "description": "Поисковый запрос"
    },
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Domains Request"
}

    #response_schema => '',
}}

# ===============================================
#
#     Inboxes
#
# ===============================================

sub inbox {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/inbox/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "text",
    "recipients"
  ],
  "properties": {
    "text": {
      "type": "string"
    },
    "recipients": {
      "items": {
        "properties": {
          "login": {
            "type": "string"
          },
          "id": {
            "type": "integer",
            "format": "int32"
          }
        },
        "title": "Inbox User Request"
      },
      "type": "array"
    }
  },
  "title": "Inbox Request"
}

    #response_schema => '',
}}

sub inbox_get {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/inbox/{post_id}/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub inbox_change {{
    method    => 'PATCH',
    url       => 'https://dirty.ru/api/inbox/{post_id}/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "properties": {
    "text": {
      "type": "string"
    },
    "recipients": {
      "items": {
        "properties": {
          "login": {
            "type": "string"
          },
          "id": {
            "type": "integer",
            "format": "int32"
          }
        },
        "title": "Inbox User Request"
      },
      "type": "array"
    }
  },
  "title": "Loose Inbox Request"
}

    #response_schema => '',
}}

sub inbox_comments {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/inbox/{inbox_id}/comments/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub inbox_comments_write {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/inbox/{inbox_id}/comments/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "body"
  ],
  "properties": {
    "body": {
      "type": "string"
    },
    "parent_comment_id": {
      "type": "integer",
      "format": "int32"
    },
    "media_id": {
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Create Inbox Comment Request"
}

    #response_schema => '',
}}

sub inbox_view {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/inbox/{inbox_id}/view/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

sub inboxes {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/inboxes/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "sort": {
      "default": "last_activity",
      "type": "string"
    },
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Inboxes Request"
}

    #response_schema => '',
}}

sub inboxes_unread {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/inboxes/unread/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "per_page",
    "page"
  ],
  "properties": {
    "sort": {
      "default": "last_activity",
      "type": "string"
    },
    "per_page": {
      "default": 42,
      "type": "integer",
      "format": "int32"
    },
    "page": {
      "default": 1,
      "type": "integer",
      "format": "int32"
    }
  },
  "title": "Inboxes Request"
}

    #response_schema => '',
}}

sub inboxes_unread_count {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/inboxes/unread/count/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

# ===============================================
#
#     Translations
#
# ===============================================

sub posts_events {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/posts/{post_id}/events/',

    request_schema => '',

    #response_schema => '',
}}

sub posts_events_add {{
    method    => 'POST',
    url       => 'https://dirty.ru/api/posts/{post_id}/events/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "blocks"
  ],
  "properties": {
    "important": {
      "type": "boolean"
    },
    "blocks": {
      "oneOf": [
        {
          "required": [
            "text",
            "type"
          ],
          "properties": {
            "text": {
              "type": "string"
            },
            "type": {
              "enum": [
                "text"
              ],
              "type": "string",
              "format": "Constant string"
            }
          },
          "title": "Text Block"
        },
        {
          "required": [
            "url",
            "align",
            "type"
          ],
          "properties": {
            "url": {
              "type": "string",
              "format": "url"
            },
            "align": {
              "enum": [
                "right",
                "center",
                "left"
              ],
              "type": "string"
            },
            "type": {
              "enum": [
                "embed"
              ],
              "type": "string",
              "format": "Constant string"
            }
          },
          "title": "Embed Block"
        },
        {
          "required": [
            "url",
            "type"
          ],
          "properties": {
            "url": {
              "type": "string",
              "format": "url"
            },
            "type": {
              "enum": [
                "image"
              ],
              "type": "string",
              "format": "Constant string"
            }
          },
          "title": "Event Image Block"
        }
      ],
      "type": "array"
    }
  },
  "title": "Stream Event Request"
}

    #response_schema => '',
}}

sub posts_events_get {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/posts/{post_id}/events/{event_id}/',

    request_schema => <<'',

    #response_schema => '',
}}

sub posts_events_change {{
    method    => 'PUT',
    url       => 'https://dirty.ru/api/posts/{post_id}/events/{event_id}/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "blocks"
  ],
  "properties": {
    "important": {
      "type": "boolean"
    },
    "blocks": {
      "oneOf": [
        {
          "required": [
            "text",
            "type"
          ],
          "properties": {
            "text": {
              "type": "string"
            },
            "type": {
              "enum": [
                "text"
              ],
              "type": "string",
              "format": "Constant string"
            }
          },
          "title": "Text Block"
        },
        {
          "required": [
            "url",
            "align",
            "type"
          ],
          "properties": {
            "url": {
              "type": "string",
              "format": "url"
            },
            "align": {
              "enum": [
                "right",
                "center",
                "left"
              ],
              "type": "string"
            },
            "type": {
              "enum": [
                "embed"
              ],
              "type": "string",
              "format": "Constant string"
            }
          },
          "title": "Embed Block"
        },
        {
          "required": [
            "url",
            "type"
          ],
          "properties": {
            "url": {
              "type": "string",
              "format": "url"
            },
            "type": {
              "enum": [
                "image"
              ],
              "type": "string",
              "format": "Constant string"
            }
          },
          "title": "Event Image Block"
        }
      ],
      "type": "array"
    }
  },
  "title": "Stream Event Request"
}

    #response_schema => '',
}}

sub posts_events_delete {{
    method    => 'DELETE',
    url       => 'https://dirty.ru/api/posts/{post_id}/events/{event_id}/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

# ===============================================
#
#     Media
#
# ===============================================

sub images {{
    method => 'POST',
    url    => 'https://dirty.ru/api/images/',

    mime_type => 'multipart/form-data',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => '',

    #response_schema => '',
}}

# ===============================================
#
#     Autocomplete
#
# ===============================================

sub autocomplete_users {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/autocomplete/users/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "q"
  ],
  "properties": {
    "q": {
      "type": "string",
      "description": "Префикс логина пользователя"
    },
    "limit": {
      "default": 10,
      "type": "integer",
      "description": "Максимальное число пользователей в результате",
      "format": "int32"
    }
  },
  "title": "Users Autocomplete Request"
}

    #response_schema => '',
}}

sub autocomplete_tags {{
    method    => 'GET',
    url       => 'https://dirty.ru/api/autocomplete/tags/',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',
{
  "required": [
    "q"
  ],
  "properties": {
    "q": {
      "type": "string",
      "description": "Префикс тэга пользователя"
    },
    "limit": {
      "default": 10,
      "type": "integer",
      "description": "Максимальное число тэгов в результате",
      "format": "int32"
    }
  },
  "title": "Tags Autocomplete Request"
}

    #response_schema => '',
}}

=cut

sub {{
    method => 'POST',
    url    => '',

    http_headers => {
        uid => 'X-Futuware-UID',
        sid => 'X-Futuware-SID',
    },

    request_schema => <<'',

    #response_schema => '',
}}

=cut

1;