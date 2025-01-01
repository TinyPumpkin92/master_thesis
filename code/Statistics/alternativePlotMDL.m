num_clusters = 1:8;

figure;
hold on
subplot(3,1,1);
plot(num_clusters, errors, 'b');
legend('Total model error');
xlabel('K');
subplot(3,1,2);
plot(num_clusters, regularizations, 'r');
legend('Model regularization');
xlabel('K');
subplot(3,1,3);
plot(num_clusters, err_reg, 'g');
legend('Total model error plus regularization');
xlabel('K');
hold off