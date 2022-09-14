unit NumericDocumentKindIdResolver;

interface

uses

  DocumentKindIdResolver,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TNumericDocumentKindIdResolver = class (TInterfacedObject, IDocumentKindIdResolver)

    public

      function ResolveIdForDocumentKind(
        DocumentKind: TDocumentKindClass
      ): Variant; virtual;

      function ResolveIdForDocumentKindAsApproveable(
        DocumentKind: TDocumentKindClass
      ): Variant; virtual;
      
  end;
  
implementation

{ TNumericDocumentKindIdResolver }

function TNumericDocumentKindIdResolver.ResolveIdForDocumentKind(
  DocumentKind: TDocumentKindClass): Variant;
begin

  if DocumentKind = TServiceNoteKind then
    Result := 2

  else if DocumentKind = TIncomingServiceNoteKind then
    Result := 3

  else if DocumentKind = TApproveableServiceNoteKind then
    Result := 4
    
  else raise Exception.Create(
                '�� ������� ���������� ������������� ' +
                '���� ���������'
             );
       
end;

function TNumericDocumentKindIdResolver.
  ResolveIdForDocumentKindAsApproveable(
    DocumentKind: TDocumentKindClass
  ): Variant;
begin

  { refactor: ���������� ������� ����� �������,
    � ������� �� ����������� ����� ���� ����������
    ����� ���� �����������
  }
  if DocumentKind.InheritsFrom(TIncomingDocumentKind) then
    raise Exception.Create(
      '������� ����������� �������������� ' +
      '��������� ���� ���������� � �������� ' +
      '������������'
    );

  if not DocumentKind.InheritsFrom(TOutcomingDocumentKind) then
    raise Exception.Create(
      '��� ����������� �������������� ' +
      '���� ���������� � �������� ������������ ' +
      '������ ���� ������� ��������� ��� ����������'
    );

  if DocumentKind = TServiceNoteKind then
    Result := 4

  else
    raise Exception.Create(
      '����������� �������������� ' +
      '��� �������������� ���� ���������� ' +
      '� �������� ������������ ' +
      '�� �����������'
    );
  
end;

end.
