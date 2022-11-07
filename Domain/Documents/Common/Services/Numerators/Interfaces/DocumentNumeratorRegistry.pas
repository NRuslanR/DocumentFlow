unit DocumentNumeratorRegistry;

interface

uses

  StandardDocumentNumerator,
  DomainException,
  Department,
  Document;

type

  TDocumentNumeratorRegistryException = class (TDomainException)
  
  end;

  {
    refactor: ��������� ������������� ������������
    ������������� ��� ������ ���������� ���� ��������� � ����
    �������������. �������� ��������� ������ ��
    function (Document: TDocument): TDocumentNumerator;
    ��� ��������� �������� ��������������� ���������
    � ����������� �� ��� ����. ��������, ��� ���������
    ������� ����� ���������� ����� �������� ��� ��������� �
    ������������� ���������� (��������, �������� ������,
    ������� ����� ���������� ������ �������������); ���
    �������� �������� ���������� nil ��� �� ����������� ����������
    �� ���������� ����������� (�������� � ������ ��� ���� ���������� �����,
    �� � ���������� OrRaise - ����� ����������� ���������� � ������,
    ���� ��������� �� ������); � ������ ������� ����� �����
    �������� ������ ��� ���������. ����������� ����, ����� �������
    ��������� ����� (������������ ������������� ���������� ��� ���),
    ������ ���� ����������� � ������ ���������� ������
  }

  IDocumentNumeratorRegistry = interface

    function GetDocumentNumeratorFor(
      DocumentType: TDocumentClass;
      const DepartmentId: Variant
    ): TDocumentNumerator;

  end;

implementation

end.
