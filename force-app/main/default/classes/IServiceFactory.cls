public interface IServiceFactory {
    void setMock(Object mockInstance);
    Object getService();
}
