use utf8;
{
    auto_container_class => 'form-group',
    elements => [
        { type => 'Hidden',
          name => 'id' },

        { type => 'Select',
          name => 'plaintiffs',
          label => 'Assistidos',
          model_config => { resultset => 'Person' },
          attrs => { class => 'form-control select-people', multiple => 'multiple' } },

        { type => 'Select',
          name => 'representants',
          label => 'Representantes Legais',
          model_config => { resultset => 'Person' },
          attrs => { class => 'form-control select-people', multiple => 'multiple' } },

        { type => 'Select',
          name => 'defendants',
          label => 'Requeridos',
          model_config => { resultset => 'Person' },
          attrs => { class => 'form-control select-people', multiple => 'multiple' } },

        { type => 'Select',
          name => 'process_type_id',
          label => 'Tipo',
          model_config => { resultset => 'ProcessType' },
          attrs => { class => 'form-control' } },

        { type => 'Select',
          name => 'keepers',
          label => 'Responsáveis',
          model_config => {
              resultset => 'User',
              label_column => 'name'
          },
          attrs => { class => 'form-control select-users', multiple => 'multiple' } },

        { type => 'Select',
          name => 'class_id',
          label => 'Turma',
          model_config => {
              resultset => 'Class',
          },
          attrs => { class => 'form-control' } },

        { type => 'Text',
          name => 'judicial_process_number',
          label => 'Nº do processo judicial (quando houver)',
          attrs => { class => 'form-control' } },

        { type => 'Textarea',
          name => 'description',
          label => 'Descrição',
          attrs => { class => 'form-control' } },

        { type => 'Select',
          name => 'status',
          label => 'Status',
          options => [ [ 'Tramitando' => 'Tramitando' ],
                       [ 'Concluído' => 'Concluído' ] ],
          attrs => { class => 'form-control' } },

        { type => 'Select',
          name => 'active',
          label => 'Ativação',
          options => [ [ '1' => 'Ativo' ], [ '0' => 'Inativo' ] ],
          attrs => { class => 'form-control' } },

        { type => 'Submit',
          value => 'Enviar',
          attrs => { class => 'btn btn-primary' } },
    ],
}
