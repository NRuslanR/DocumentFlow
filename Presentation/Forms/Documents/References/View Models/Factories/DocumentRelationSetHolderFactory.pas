unit DocumentRelationSetHolderFactory;

interface

uses

  DocumentRelationSetHolder,
  AbstractDataSetHolder,
  AbstractDataSetHolderFactory,
  DB,
  DataSetBuilder,
  SysUtils,
  Classes;

type

  IDocumentRelationSetHolderFactory = interface (IDataSetHolderFactory)
    ['{0FF73473-5A4A-45C7-A392-F37441EE211F}']
    
    function CreateDocumentRelationSetHolder: TDocumentRelationSetHolder;
    
  end;

  TDocumentRelationSetHolderFactory = class (TAbstractDataSetHolderFactory, IDocumentRelationSetHolderFactory)

    protected

      function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
      procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

      procedure CustomizeDataSetBuilder(
        DataSetBuilder: IDataSetBuilder;
        DataSetHolder: TAbstractDataSetHolder
      ); override;
      
    public

      function CreateDocumentRelationSetHolder: TDocumentRelationSetHolder;

  end;
  
implementation

{ TDocumentRelationSetHolderFactory }

function TDocumentRelationSetHolderFactory.CreateDocumentRelationSetHolder: TDocumentRelationSetHolder;
begin

  Result := TDocumentRelationSetHolder(CreateDataSetHolder);
  
end;

function TDocumentRelationSetHolderFactory.InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentRelationSetHolder.Create;

end;

procedure TDocumentRelationSetHolderFactory.FillDataSetFieldDefs(
  FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);

  with TDocumentRelationSetFieldDefs(FieldDefs) do begin

    DocumentIdFieldName := 'id';
    DocumentKindIdFieldName := 'type_id';
    DocumentKindNameFieldName := 'type_name';
    DocumentNameFieldName := 'name';
    DocumentNumberFieldName := 'number';
    DocumentDateFieldName := 'document_date';
    
  end;

end;

procedure TDocumentRelationSetHolderFactory.CustomizeDataSetBuilder(
  DataSetBuilder: IDataSetBuilder; DataSetHolder: TAbstractDataSetHolder);
begin

  inherited CustomizeDataSetBuilder(DataSetBuilder, DataSetHolder);

  with TDocumentRelationSetHolder(DataSetHolder).FieldDefs do begin

    DataSetBuilder
      .AddField(DocumentIdFieldName, ftInteger)
      .AddField(DocumentNumberFieldName, ftString, 100)
      .AddField(DocumentDateFieldName, ftDateTime)
      .AddField(DocumentNameFieldName, ftString, 300)
      .AddField(DocumentKindIdFieldName, ftInteger)
      .AddField(DocumentKindNameFieldName, ftString, 100)

  end;
  
end;

end.
