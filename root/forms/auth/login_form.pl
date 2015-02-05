use utf8;
{
    auto_container_class => 'form-group',
    elements => [
        { type => 'Text',
          name => 'username',
          attrs => { class => 'form-control',
                     placeholder => 'Login' },
        },
        { type => 'Password',
          name => 'password',
          attrs => { class => 'form-control',
                     placeholder => 'Senha' },
        },
        { type => 'Submit',
          value => 'Enviar',
          attrs => { class => 'btn btn-primary' } },
    ],
}
